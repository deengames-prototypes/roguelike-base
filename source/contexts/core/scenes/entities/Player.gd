class_name Player
extends BaseEntity

const Aimer = preload("res://contexts/core/scenes/ui/Aimer.tscn")

var direction_vectors = {
	"right": Vector2.RIGHT,
	"left": Vector2.LEFT,
	"up": Vector2.UP,
	"down": Vector2.DOWN
}

# For monsters to know if they can hit us when we move. E.g. if they try to melee
# but we move out of range, they shouldn't hit us. If we move from bow-range to
# bow-range, or spell-range to spell-range, we're still hittable.
var moving_to_tile:Vector2i

var is_aiming:bool = false


# TODO: GOES INTO DATA
var health_left:int = 4
var firing_range:int = 5 # 0 to disable

func _unhandled_key_input(event:InputEvent) -> void:
	if is_moving or is_aiming:
		return
	
	# Clear who is moving where this turn
	BaseEntity.moving_next_turn.fill(null)
	
	if Input.is_action_just_pressed("ui_accept"):
		pass_turn()
	
	if firing_range > 0 and Input.is_action_just_pressed("fire_projectile"):
		handle_aim_and_fire()

	handle_movement(event)

func pass_turn():
	move(Vector2.ZERO)

func pre_move():
	CoreEventBus.player_moving.emit()

func post_move():
	self.moving_to_tile = Vector2i(self.position / TILE_SIZE)

func hurt():
	self.health_left -= 1
	if self.health_left <= 0:
		CoreEventBus.player_died.emit()
		self.queue_free()

func handle_movement(event: InputEvent) -> void:
	for direction in direction_vectors.keys():
		var direction_vector:Vector2i = direction_vectors[direction]
		if event.is_action_pressed("ui_%s" % direction):
			if not can_move(direction_vector):
				var whos_there = get_melee_target(direction_vector)
				if whos_there != null:
					handle_melee(whos_there, direction_vector)
					return
					
				# Blocked but not hittable/breakable, e.g. wall
				continue
				
			# First spot that's walkable
			self.moving_to_tile = Vector2i(self.position / TILE_SIZE) + direction_vector
			move(direction_vector)
			break

func handle_aim_and_fire() -> void:
	is_aiming = true
	var aimer = Aimer.instantiate()
	aimer.position = self.position
	
	get_parent().add_child(aimer) # starts aiming automagically
	var target = await aimer.picked_target
	
	get_parent().remove_child(aimer)
	print("fire at %s" % target)
	is_aiming = false

func handle_melee(target:Monster, direction_vector:Vector2i) -> void:
	target.hurt()
	var tween = ActionTweener.attack(create_tween(), self, direction_vector)
	await tween.finished
	pass_turn()
