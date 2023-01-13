extends Area2D

@export var speed = 250
@export var friction = 0.01
@export var acceleration = 0.1

var sword_rot_deg: float = 0.0

@onready var attack_zone: Area2D = get_node("AttackZone")
@onready var ray_cast: RayCast2D = get_node("RayCast2D")
@onready var trm_move: Timer = get_node("TrmMove")

const TILE_SIZE: int = 16


enum MOVING_DIR {
	NONE,
	UP,
	DOWN,
	LEFT,
	RIGHT
}

var moving_state: MOVING_DIR

func _ready() -> void:
	self.position = self.position.snapped(Vector2.ONE * TILE_SIZE)
	self.position += Vector2.ONE * TILE_SIZE/2
	self.moving_state = MOVING_DIR.NONE
	self._connect_signals()
	self.trm_move.start(0.09)
	

func _connect_signals() -> void:
	self.trm_move.connect("timeout", self._move2)

func get_input():
	#velocity = Vector2()
	if Input.is_action_pressed('move_right'):
		
		moving_state = MOVING_DIR.RIGHT
	elif Input.is_action_pressed('move_left'):

		moving_state = MOVING_DIR.LEFT
	elif Input.is_action_pressed('move_down'):

		moving_state = MOVING_DIR.DOWN
	elif Input.is_action_pressed('move_up'):

		moving_state = MOVING_DIR.UP
	

func _unhandled_input(event):
	if event.is_action_pressed("dash"):
		self._dash()
	
	if event.is_action_pressed("attack"):
		self._attack()

func _update_direction() -> void:
	pass
	
#func _move() -> void:
#
#	match self.moving_state:
#		MOVING_DIR.NONE:
#			velocity = Vector2.ZERO
#		MOVING_DIR.RIGHT:
#			velocity = Vector2.ZERO
#			velocity.x += 1
#		MOVING_DIR.LEFT:
#			velocity = Vector2.ZERO
#			velocity.x -= 1
#		MOVING_DIR.DOWN:
#			velocity = Vector2.ZERO
#			velocity.y += 1
#		MOVING_DIR.UP:
#			velocity = Vector2.ZERO
#			velocity.y -= 1

func _physics_process(delta):
	
	get_input()
	if !self.is_colliding():
		pass
		#_move2(Vector2.RIGHT)
	
	#_move()
	_rotate_attack_zone(self.moving_state)
	#####velocity = velocity.normalized() * speed
	######move_and_slide()

func is_colliding() -> bool:
	if self.ray_cast.is_colliding():
		print(self.ray_cast.get_collider())
	return self.ray_cast.is_colliding()

func _dash() -> void:
	match self.moving_state:
		MOVING_DIR.NONE:
			position = position
		MOVING_DIR.RIGHT:
			position.x += 50
		MOVING_DIR.LEFT:
			position.x -= 50
		MOVING_DIR.DOWN:
			position.y += 50
		MOVING_DIR.UP:
			position.y -= 50
	print('dash!')

func _attack() -> void:
	# TODO: Create a twenn that rotation the sword
	$AnimationPlayer.play("swing_sword")
	print('attack')

func _move2() -> void:
	var current_dir: Vector2
	
	#self.global_position = self.global_position.snapped(Vector2.ONE * TILE_SIZE)
	match self.moving_state:
		MOVING_DIR.NONE:
			current_dir = Vector2.ZERO
		MOVING_DIR.RIGHT:
			current_dir = Vector2.RIGHT
		MOVING_DIR.LEFT:
			current_dir = Vector2.LEFT
		MOVING_DIR.DOWN:
			current_dir = Vector2.DOWN
		MOVING_DIR.UP:
			current_dir = Vector2.UP
	
	self.position += current_dir * TILE_SIZE 
	


func _rotate_attack_zone(mov_state: MOVING_DIR) -> void:
	var new_rot_deg: float
	match  mov_state:
		MOVING_DIR.NONE:
			new_rot_deg = 0
		MOVING_DIR.RIGHT:
			new_rot_deg = 0
		MOVING_DIR.LEFT:
			new_rot_deg = -180
		MOVING_DIR.DOWN:
			new_rot_deg = 90
		MOVING_DIR.UP:
			new_rot_deg = -90
	
	self.attack_zone.rotation_degrees = new_rot_deg
	self.ray_cast.rotation_degrees = new_rot_deg - 90.0
