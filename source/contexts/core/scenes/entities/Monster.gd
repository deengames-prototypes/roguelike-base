class_name Monster
extends BaseEntity

var MOVEMENT_STRATEGIES = {
	"random": RandomMover
}

var mover = MOVEMENT_STRATEGIES["random"].new(self)

func _ready() -> void:
	CoreEventBus.player_moving.connect(try_to_move)
	super._ready()

func try_to_move():
	mover.try_to_move()
