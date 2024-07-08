extends Node2D

func _ready():
	CoreEventBus.player_moving.connect(move_monsters)

func move_monsters():
	var monsters = get_tree().get_nodes_in_group("Monsters")
	
	for monster in monsters:
		if monster == null or not is_instance_valid(monster):
			continue
		
		monster.try_to_move()
