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

func move(direction:Vector2i):
	var move_diff:Vector2 = Vector2(direction * TILE_SIZE)
	var destination:Vector2 = self.position + move_diff
	
	# Check if we can move, or if someone else is moving there
	if not can_move(direction):
		print("Last minute cancel from %s" % self.name)
		return
	
	var delete_me = %CollisionShape2D.duplicate()
	delete_me.position = destination + delete_me.shape.size / 2
	get_parent().add_child(delete_me)
	
	var tween = create_tween()
	tween.tween_property(self, "position", destination, MOVE_TIME_SECONDS).set_trans(Tween.TRANS_SINE)
	
	is_moving = true
	pre_move()

	await tween.finished

	is_moving = false
	delete_me.queue_free()
	post_move()
	
# Virtual methods. Override please.
func pre_move(): pass
func post_move(): pass
