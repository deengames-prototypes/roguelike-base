class_name Monster
extends BaseEntity

var MOVEMENT_STRATEGIES = {
	"random": RandomStrategy,
	"hunt": HuntStrategy
}

@onready var player = get_tree().get_first_node_in_group("Player")
var movement_strategy = MOVEMENT_STRATEGIES["hunt"].new(self)

func _ready() -> void:
	super._ready()
	add_child(movement_strategy) # just in-case it needs access to, say, the player.
	
	CoreEventBus.player_moving.connect(try_to_move)

func try_to_move():
	# Check if the player is in melee range
	var distance_to_player:Vector2 = (player.position - self.position) / TILE_SIZE
	if distance_to_player.length() <= 1:
		player.hurt()
		ActionTweener.attack(create_tween(), self, distance_to_player.normalized())
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
