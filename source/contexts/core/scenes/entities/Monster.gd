class_name Monster
extends BaseEntity

var MOVEMENT_STRATEGIES = {
	"random": RandomStrategy,
	"hunt": HuntStrategy
}

@onready var player:Player = get_tree().get_first_node_in_group("Player")
var movement_strategy = MOVEMENT_STRATEGIES["hunt"].new(self)

func _ready() -> void:
	super._ready()
	add_child(movement_strategy) # just in-case it needs access to, say, the player.
	
	CoreEventBus.player_moving.connect(try_to_move)

func try_to_move():
	# Check if the player is in melee range. Not where they are now, but where they're going to be
	# after they move. (Did they move from within to out-of melee range? Then we can't hit them.)
	var my_tile_position = Vector2i(self.position / TILE_SIZE)
	var distance_to_player:Vector2 = (player.moving_to_tile - my_tile_position)
	if distance_to_player.length() <= 1:
		player.hurt()
		ActionTweener.attack(create_tween(), self, distance_to_player.normalized())
		return
	
	if distance_to_player.length() <= firing_range:
		projectile_shooter.shoot(player, "monster")
		projectile_shooter.hit.connect(func(hit_who):
			# May have hit someone between us and the player. Lol.
			if not hit_who is TileMap:
				hit_who.hurt()
		)
		return
	
	# Nah, he's not melee-able. Move. According to our strategy.
	var possible_moves = movement_strategy.get_moves()
	possible_moves.shuffle()

	# Make sure these are legit
	for p in possible_moves:
		if not self.can_move(p):
			continue
		
		# Try to move. If we fail, keep going.
		if await self.move(p):
			break

func hurt():
	self.queue_free()
