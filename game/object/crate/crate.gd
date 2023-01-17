extends Area2D

const TILE_SIZE: int = 16

# Called when the node enters the scene tree for the first time.
func _ready():
	self.position = self.position.snapped(Vector2.ONE * TILE_SIZE)
	self.position += Vector2.ONE * TILE_SIZE/2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
