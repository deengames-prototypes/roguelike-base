extends Node

# Picked a destination tile, about to tween
signal player_moving

# Done tweening to his new place
signal player_moved

signal player_died # Game over, in other words
signal monster_died(who)
