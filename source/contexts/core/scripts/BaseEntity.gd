class_name BaseEntity
extends Area2D

const MOVE_TIME_SECONDS:float = 0.25
const TILE_SIZE:int = 32

var is_moving:bool = false
var ray:RayCast2D

func _ready():
	ray = %RayCast2D

func can_move(direction:Vector2i) -> bool:
	ray.target_position = direction * TILE_SIZE
	ray.force_raycast_update()
	return not ray.is_colliding()

func move(direction:Vector2i, emit_events:bool = false):
	var tween = create_tween()
	var destination:Vector2 = self.position + Vector2(direction * TILE_SIZE)
	tween.tween_property(self, "position", destination, MOVE_TIME_SECONDS).set_trans(Tween.TRANS_SINE)
	
	is_moving = true

	if emit_events: 
		CoreEventBus.player_moving.emit()

	await tween.finished
	is_moving = false

	if emit_events:
		CoreEventBus.player_moved.emit()
	
