extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	player_pos_to_grid()

func get_player_pos():
	return $Player.global_position

func player_pos_to_grid():
	print($TestTileMap.local_to_map(get_player_pos()))
