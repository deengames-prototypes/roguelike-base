class_name Monster
extends BaseEntity

var MOVEMENT_STRATEGIES = {
	"random": RandomStrategy,
	"hunt": HuntStrategy
}

@onready var player:Player = get_tree().get_first_node_in_group("Player")
var movement_strategy = MOVEMENT_STRATEGIES["hunt"].new(self)

# TODO: MOVE INTO DATA
# NOTE: The order of skills = the order checked. TODO: sort by range...
var skills =  {
	#"chomp": { "range": 1, "damage": 40 },
	#"projectile vomit": { "range": 2, "damage_multiplier": 1.5 },
}

func _ready() -> void:
	super._ready()
	add_child(movement_strategy) # just in-case it needs access to, say, the player.
	CoreEventBus.player_moving.connect(try_to_move)

func try_to_move():
	# Check if the player is in range. Not where he is now, but where he's going to be
	# after he moves. (Did he move from within range to out-of-range? Then we can't hit the little git.)
	var my_tile_position = Vector2i(self.position / TILE_SIZE)
	var direction_to_player:Vector2 = (player.moving_to_tile - my_tile_position)
	var distance_to_player:float = direction_to_player.length()
	
	# Use skills first. Because that makes more interesting and intense battles. It's not random.
	for skill_name in skills:
		var skill_data = skills[skill_name]
		if skill_data["range"] >= distance_to_player:
			# 🗡️💀
			var damage = self.strength
			if "damage_multiplier" in skill_data:
				damage *= skill_data["damage_multiplier"]
			if "damage" in skill_data:
				damage += skill_data["damage"]
			damage = int(round(damage))
			var damage_inflicted = player.hurt(damage)
			CoreEventBus.log_to_console.emit("%s uses %s! %s damage!" % [self.name, skill_name, damage_inflicted])
			return
	
	if distance_to_player <= 1:
		var damage_type = ["normal", "special", "fire", "ice", "metal", "earth"].pick_random()
		var damage = player.hurt(100, damage_type)
		CoreEventBus.log_to_console.emit("%s melees you for %s damage!" % [self.name, damage])
		ActionTweener.attack(create_tween(), self, direction_to_player.normalized())
		return
		
	# If this monster has a ranged attack, fire at the player (if in range).
	elif distance_to_player <= firing_range:
		projectile_shooter.shoot(player, "monster")
		projectile_shooter.hit.connect(func(hit_who):
			# May have hit someone between us and the player. Lol.
			if not hit_who is TileMap:
				var damage = hit_who.hurt()
				CoreEventBus.log_to_console.emit("%s shoots %s for %s damage!" % [self.name, hit_who.name, damage])
		)
		return
	
	# Nah, he's not melee-able. Move. According to our strategy.
	var possible_moves = movement_strategy.get_moves()
	possible_moves.shuffle()

	# Make sure these are legit
	for p in possible_moves:
		if not self.can_move(p):
			continue
		
		# Try to move. If we fail (e.g. someone else just moved there), keep iterating.
		if await self.move(p):
			break
