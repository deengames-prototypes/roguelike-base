class_name BaseEntity
extends Area2D

const TILE_SIZE:int = 32

var is_moving:bool = false
var ray:RayCast2D
var projectile_shooter = ProjectileShooter.new()

# TODO: GOES INTO DATA
var health_left:int = 4
var firing_range:int = 5 # 0 to disable

static var moving_next_turn:Array2D = Array2D.new(1000, 1000)

func _ready():
	ray = %RayCast2D
	add_child(projectile_shooter)

	self.firing_range = 3

func can_move(direction:Vector2) -> bool:
	ray.target_position = direction.normalized() * TILE_SIZE
	ray.force_raycast_update()
	return not ray.is_colliding()

func get_melee_target(direction:Vector2) -> BaseEntity:
	ray.target_position = direction.normalized() * TILE_SIZE
	ray.force_raycast_update()
	var target = ray.get_collider()
	
	if target is TileMap:
		return null
	
	return target

# Returns true if moved. Maybe not, because someone else is moving there first.
func move(direction:Vector2i) -> bool:
	var move_diff:Vector2 = Vector2(direction * TILE_SIZE)
	var destination:Vector2 = self.position + move_diff
	var tile_destination = Vector2i(destination / TILE_SIZE)
	
	# Check if we can move, or if someone else is moving there
	if moving_next_turn.get_at(tile_destination):
		return false
	
	moving_next_turn.set_at(tile_destination, self)
	var tween = ActionTweener.move(create_tween(), self, destination)
	
	is_moving = true
	pre_move()

	await tween.finished

	moving_next_turn.set_at(tile_destination, null)
	is_moving = false
	post_move()
	
	return true
	
# Virtual methods. Override please.
func pre_move(): pass
func post_move(): pass
