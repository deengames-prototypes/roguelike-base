class_name BaseEntity
extends Area2D

const TILE_SIZE:int = 32

var is_moving:bool = false
var ray:RayCast2D
var projectile_shooter = ProjectileShooter.new()

# TODO: GOES INTO DATA
var health_left:int = 400

var strength:int = 3 # base damage
var tougness:int = 2 # base block
var special_defense:int = 1

# elemental => % blocked. Max is 1.0. No negatives allowed. Keep it simple.
var elemental_defense = {
	"fire": 0.5,
	"ice": 0.8,
	"lightning": 0.2
}

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
	
### Hurts this guy for the damage amount indicated, maybe (apply toughness etc.)
# Returns the *actual* damage inflicted.
# Elementals: normal (vs. toughness), special (vs. special defense), or ... elemental, e.g. fire/ice
func hurt(raw_damage:int = 1, elemental:String = "normal"):
	var damage = 0
	
	match elemental:
		"normal": damage = raw_damage - self.tougness
		"special": damage = raw_damage - self.special_defense
		_: 
			if elemental in elemental_defense:
				damage = raw_damage * (1 - elemental_defense[elemental])
			else:
				damage = raw_damage
	
	damage = max(damage, 0) # ensure no negative damage
	self.health_left -= damage
	if self.health_left <= 0:
		pre_death()
		self.queue_free()
	
	return damage
	
# Virtual methods. Override please.
func pre_move(): pass
func post_move(): pass
func pre_death(): pass
