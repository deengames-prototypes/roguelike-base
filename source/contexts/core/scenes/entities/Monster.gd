class_name Monster
extends Node2D

# Used to coordinate between move/melee/ranged/skill systems. 
# Did the monster use their turn up this round?
# Can change to int and decrement on use to allow multiple actions within a single
# turn, e.g. move and then shoot.
var used_turn:bool = false

var stalking_range:int = 5 # depends on the monster

func hurt():
	return ######################################
	self.queue_free() #lolwut
	CoreEventBus.monster_died.emit(self)
