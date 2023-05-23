class_name PlayerStateMachine
extends Node2D

const GRAVITY = 400
const GRAVITY_MAX = 500
const MOVEMENT_SPEED = 150
const JUMP_FORCE = 150

var _max_double_jumps: int = 2
var _double_jumps: int = _max_double_jumps

var _permanent_state: CharacterBody2D
var _raycast_right: RayCast2D
var _raycast_left: RayCast2D


enum {IDLE, WALK, FALL, JUMP, DOUBLE_JUMP}
var _current_state = IDLE
var _enter_state = true

func setup(_permanent_state_arg: CharacterBody2D, 
	_raycast_right_arg: RayCast2D,
	_raycast_left_arg: RayCast2D):
		
	_permanent_state = _permanent_state_arg
	_raycast_right = _raycast_right_arg
	_raycast_left = _raycast_left_arg
	
	
func _physics_process(delta):
	match _current_state:
		IDLE:
			_idle_state(delta)
		WALK:
			_walk_state(delta)
		FALL:
			_fall_state(delta)
		JUMP:
			_jump_state(delta)
		DOUBLE_JUMP:
			_double_jump(delta)
	
	
# state functions
func _idle_state(_delta):
	if _enter_state:
		_double_jumps = _max_double_jumps
	
	_apply_gravity(_delta)
	_apply_lerp_x()
	_apply_move_and_slide()
	
	_set_state(_check_idle_state())
	
func _walk_state(_delta):
	if _enter_state:
		_double_jumps = _max_double_jumps
		
	_apply_gravity(_delta)
	_apply_movement()
	_apply_lerp_x()
	_apply_move_and_slide()
	
	_set_state(_check_walk_state())
	
func _fall_state(_delta):
	_apply_gravity(_delta)
	_apply_movement()
	_apply_lerp_x()
	_apply_move_and_slide()
	
	_set_state(_check_fall_state())
	
func _jump_state(_delta):
	if _enter_state:
		_permanent_state.velocity.y = -JUMP_FORCE
		
	_apply_gravity(_delta)
	_apply_movement()
	_apply_lerp_x()
	_apply_move_and_slide()
	
	_set_state(_check_jump_state())
	
func _double_jump(_delta):
	if _enter_state:
		_permanent_state.velocity.y = -JUMP_FORCE
		_double_jumps -= 1
		
	_apply_gravity(_delta)
	_apply_movement()
	_apply_lerp_x()
	_apply_move_and_slide()
	
	_set_state(_check_double_jump_state())
	
# check functions
func _check_idle_state():
	var new_state = IDLE
	if Input.is_action_pressed("move_right") or Input.is_action_pressed("move_left"):
		new_state = WALK
	elif Input.is_action_pressed("jump"):
		new_state = JUMP
	elif not _permanent_state.is_on_floor():
		new_state = FALL
	return new_state
	
func _check_walk_state():
	var new_state = WALK
	if !Input.is_action_pressed("move_right") and !Input.is_action_pressed("move_left"):
		new_state = IDLE
	elif Input.is_action_pressed("jump"):
		new_state = JUMP
	elif not _permanent_state.is_on_floor():
		new_state = FALL
	return new_state
	
func _check_fall_state():
	var new_state = FALL
	if _permanent_state.is_on_floor() and Input.get_axis("move_left", "move_right") == 0:
		new_state = IDLE
	elif _permanent_state.is_on_floor() and Input.get_axis("move_left", "move_right") != 0:
		new_state = WALK
	elif Input.is_action_pressed("jump") and _double_jumps != 0:
		new_state = DOUBLE_JUMP
	return new_state
	
func _check_jump_state():
	var new_state = JUMP
	if _permanent_state.velocity.y >= 0:
		new_state = FALL
	return new_state
	
func _check_double_jump_state():
	var new_state = DOUBLE_JUMP
	if _permanent_state.velocity.y >= 0:
		new_state = FALL
	return new_state
	
# help functions
func _apply_gravity(_delta):
	_permanent_state.velocity.y += GRAVITY * _delta
	_permanent_state.velocity.y = min(_permanent_state.velocity.y, GRAVITY_MAX)
	
func _apply_movement():
	if Input.is_action_pressed("move_right"):
		_permanent_state.velocity.x = MOVEMENT_SPEED
	if Input.is_action_pressed("move_left"):
		_permanent_state.velocity.x = -MOVEMENT_SPEED

func _apply_lerp_x():
	_permanent_state.velocity.x = lerp(_permanent_state.velocity.x, 0.0, 0.2)
	
func _apply_move_and_slide():
	_permanent_state.move_and_slide()
	
	
	
func _set_state(new_state):
	_enter_state = new_state != _current_state
	_current_state = new_state

