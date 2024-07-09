class_name ActionTweener
extends Node

const MOVE_TIME_SECONDS:float = 0.25
const TILE_SIZE:int = 32

static func move(tween:Tween, entity:BaseEntity, destination:Vector2) -> Tween:
	tween.tween_property(entity, "position", destination, MOVE_TIME_SECONDS)#.set_trans(Tween.TRANS_SINE)
	return tween

static func attack(tween:Tween, entity:Node2D, direction:Vector2) -> Tween:
	direction = direction.normalized()
	
	tween.tween_property(entity, "position", entity.position + (direction * TILE_SIZE/2), 0.1)
	tween.tween_property(entity, "position", entity.position, 0.1)
	return tween
