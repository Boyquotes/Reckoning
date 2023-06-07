extends State
class_name StatePlayer

const GRAVITY = 400
const GRAVITY_MAX = 500
const MOVEMENT_SPEED = 150
const MOVEMENT_LERP_WEIGHT = 0.2
const JUMP_FORCE = 150

var state_machine: StateMachine = null
var persistent_state: CharacterBody2D
var raycast_right: RayCast2D
var raycast_left: RayCast2D
var player_animated_sprite: AnimatedSprite2D
var sword: Node2D

func setup(_state_machine: StateMachine, 
	_persistent_state: CharacterBody2D,
	_raycast_right, _raycast_left,
	_player_animated_sprite: AnimatedSprite2D,
	_sword: Node2D):
		
	self.state_machine = _state_machine
	self.persistent_state = _persistent_state
	self.raycast_right = _raycast_right
	self.raycast_left = _raycast_left
	self.player_animated_sprite = _player_animated_sprite
	self.sword = _sword
	
func _apply_gravity(_delta):
	persistent_state.velocity.y += GRAVITY * _delta
	persistent_state.velocity.y = min(persistent_state.velocity.y, GRAVITY_MAX)
	
func _apply_movement(_movement_speed):
	if Input.is_action_pressed("move_right"):
		persistent_state.velocity.x = _movement_speed
		state_machine.current_direction = 1
	if Input.is_action_pressed("move_left"):
		persistent_state.velocity.x = -_movement_speed
		state_machine.current_direction = -1
		
func _apply_lerp_x(_weight: float):
	persistent_state.velocity.x = lerp(persistent_state.velocity.x, 0.0, _weight)
	
func _apply_lerp_y(_weight: float):
	persistent_state.velocity.y = lerp(persistent_state.velocity.y, 0.0, _weight)
	
func _apply_move_and_slide():
	persistent_state.move_and_slide()
	
