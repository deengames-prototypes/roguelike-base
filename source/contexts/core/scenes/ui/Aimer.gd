extends Node2D

signal picked_target(who) # null = cancelled

const TILE_SIZE:int = 32

var player
var target

var direction_vectors = {
	"right": Vector2.RIGHT,
	"left": Vector2.LEFT,
	"up": Vector2.UP,
	"down": Vector2.DOWN
}

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		picked_target.emit(null) # cancelled
	
	for direction in direction_vectors:
		if Input.is_action_just_pressed("ui_%s" % direction):
			self.position += direction_vectors[direction] * TILE_SIZE
	
	if Input.is_action_just_pressed("fire_projectile") and target != null and target != player:
		picked_target.emit(target)

func _on_area_entered(area: Area2D) -> void:
	if area == player:
		return
		
	target = area

func _on_area_exited(area: Area2D) -> void:
	target = null
