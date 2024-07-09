class_name Player
extends BaseEntity

var direction_vectors = {
	"right": Vector2.RIGHT,
	"left": Vector2.LEFT,
	"up": Vector2.UP,
	"down": Vector2.DOWN
}

# TODO: GOES INTO DATA
var health_left:int = 4

func _unhandled_key_input(event: InputEvent) -> void:
	if is_moving:
		return
	
	# Clear who is moving where this turn
	BaseEntity.moving_next_turn.fill(null)
	
	if Input.is_action_just_pressed("ui_accept"):
		pass_turn()

	for direction in direction_vectors.keys():
		var direction_vector:Vector2i = direction_vectors[direction]
		if event.is_action_pressed("ui_%s" % direction):
			if not can_move(direction_vector):
				var whos_there = get_melee_target(direction_vector)
				if whos_there != null:
					# MELEE MELEE MELEEEEEEEEEEE
					whos_there.hurt()
					var tween = ActionTweener.attack(create_tween(), self, direction_vector)
					await tween.finished
					pass_turn()
					break
				
				# Blocked but not hittable/breakable, e.g. wall
				continue
				
			# First spot that's walkable
			move(direction_vector)
			break

func pass_turn():
	move(Vector2.ZERO)

func pre_move():
	CoreEventBus.player_moving.emit()

func post_move():
	pass

func hurt():
	self.health_left -= 1
	if self.health_left <= 0:
		CoreEventBus.player_died.emit()
		self.queue_free()
