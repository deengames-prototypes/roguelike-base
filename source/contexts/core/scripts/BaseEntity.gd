class_name BaseEntity
extends Area2D

const MOVE_TIME_SECONDS:float = 0.25
const TILE_SIZE:int = 32

var is_moving:bool = false
var ray:RayCast2D

static var moving_next_turn:Array2D = Array2D.new(1000, 1000)

func _ready():
	ray = %RayCast2D

func can_move(direction:Vector2i) -> bool:
	ray.target_position = direction * TILE_SIZE
	ray.force_raycast_update()
	return not ray.is_colliding()

func move(direction:Vector2i):
	var move_diff:Vector2 = Vector2(direction * TILE_SIZE)
	var destination:Vector2 = self.position + move_diff
	var tile_destination = Vector2i(destination / TILE_SIZE)
	
	# Check if we can move, or if someone else is moving there
	var occupied_by = moving_next_turn.get_at(tile_destination)
	if occupied_by != null and is_instance_valid(occupied_by) and occupied_by != self:
		print("%s last-minute cancel at %s" % [self.name, tile_destination])
		return
	
	moving_next_turn.set_at(tile_destination, self)
	print("%s is moving to %s" % [self, tile_destination])
	var tween = create_tween()
	tween.tween_property(self, "position", destination, MOVE_TIME_SECONDS).set_trans(Tween.TRANS_SINE)
	
	is_moving = true
	pre_move()

	await tween.finished

	moving_next_turn.set_at(tile_destination, null)
	is_moving = false
	post_move()
	
# Virtual methods. Override please.
func pre_move(): pass
func post_move(): pass
