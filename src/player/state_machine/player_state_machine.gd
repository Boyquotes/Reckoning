class_name PlayerStateMachine
extends Node2D

const GRAVITY = 400
const GRAVITY_MAX = 500
const MOVEMENT_SPEED = 150
const MOVEMENT_LERP_WEIGHT = 0.2
const JUMP_FORCE = 150
const WALL_JUMP_FORCE = 200
const WALL_JUMP_LERP_WEIGHT = 0.05
const DASH_FORCE = 400
const DASH_LERP_WEIGHT = 0.1

var _current_direction: int = 1

const MAX_DOUBLE_JUMPS: int = 1
var _double_jumps: int = MAX_DOUBLE_JUMPS

const MAX_DASHS: int = 1
var _dashs: int = MAX_DASHS
var _dash_direction: Vector2 = Vector2.ZERO

var _permanent_state: CharacterBody2D
var _raycast_right: RayCast2D
var _raycast_left: RayCast2D


enum {IDLE, WALK, FALL, JUMP, DOUBLE_JUMP, WALL_JUMP, DASH}
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
			_double_jump_state(delta)
		WALL_JUMP:
			_wall_jump_state(delta)
		DASH:
			_dash_state(delta)
	
	
# state functions
func _idle_state(_delta):
	if _enter_state:
		_reset_attributes()
	
	_apply_gravity(_delta)
	_apply_lerp_x(MOVEMENT_LERP_WEIGHT)
	_apply_move_and_slide()
	
	_set_state(_check_idle_state())
	
func _walk_state(_delta):
	if _enter_state:
		_reset_attributes()
		
	_apply_gravity(_delta)
	_apply_movement()
	_apply_lerp_x(MOVEMENT_LERP_WEIGHT)
	_apply_move_and_slide()
	
	_set_state(_check_walk_state())
	
func _fall_state(_delta):
	_apply_gravity(_delta)
	_apply_movement()
	_apply_lerp_x(MOVEMENT_LERP_WEIGHT)
	_apply_move_and_slide()
	
	_set_state(_check_fall_state())
	
func _jump_state(_delta):
	if _enter_state:
		_permanent_state.velocity.y = -JUMP_FORCE
		
	_apply_gravity(_delta)
	_apply_movement()
	_apply_lerp_x(MOVEMENT_LERP_WEIGHT)
	_apply_move_and_slide()
	
	_set_state(_check_jump_state())
	
func _double_jump_state(_delta):
	if _enter_state:
		_permanent_state.velocity.y = -JUMP_FORCE
		_double_jumps -= 1
		
	_apply_gravity(_delta)
	_apply_movement()
	_apply_lerp_x(MOVEMENT_LERP_WEIGHT)
	_apply_move_and_slide()
	
	_set_state(_check_double_jump_state())
	
func _wall_jump_state(_delta):
	if _enter_state:
		_permanent_state.velocity.y = -JUMP_FORCE
		if _raycast_right.is_colliding():
			_permanent_state.velocity.x = -WALL_JUMP_FORCE
			_current_direction = -1
		elif _raycast_left.is_colliding():
			_permanent_state.velocity.x = WALL_JUMP_FORCE
			_current_direction = 1
	
	_apply_gravity(_delta)
	_apply_lerp_x(WALL_JUMP_LERP_WEIGHT)
	_apply_move_and_slide()
	
	_set_state(_check_wall_jump_state())
	
func _dash_state(_delta):
	if _enter_state:
		_dash_direction = Vector2(0, 0)
		
		var sides = Input.get_axis("move_left", "move_right")
		var up = 0
		if Input.is_action_pressed("move_up"):
			up = 1
			
		if sides == 0 and up == 0:
			_dash_direction = Vector2(_current_direction, 0)
		elif sides == 0 and up != 0:
			_dash_direction = Vector2(0, -1)
		elif sides != 0 and up == 0:
			_dash_direction = Vector2(sides, 0)
		else:
			_dash_direction = Vector2(sides, -1)
			
		_dash_direction = _dash_direction.normalized() * DASH_FORCE
		_permanent_state.velocity = _dash_direction
		
		_pull_dash()
		
	_apply_move_and_slide()
	_apply_lerp_x(DASH_LERP_WEIGHT)
	_apply_lerp_y(DASH_LERP_WEIGHT)
	_set_state(_check_dash_state())
	
# check functions
func _check_idle_state():
	var new_state = IDLE
	if Input.is_action_pressed("move_right") or Input.is_action_pressed("move_left"):
		new_state = WALK
	elif Input.is_action_just_pressed("jump"):
		new_state = JUMP
	elif Input.is_action_just_pressed("dash") and _dashs != 0:
		new_state = DASH
	elif not _permanent_state.is_on_floor():
		new_state = FALL
	return new_state
	
func _check_walk_state():
	var new_state = WALK
	if !Input.is_action_pressed("move_right") and !Input.is_action_pressed("move_left"):
		new_state = IDLE
	elif Input.is_action_just_pressed("jump"):
		new_state = JUMP
	elif Input.is_action_just_pressed("dash") and _dashs != 0:
		new_state = DASH
	elif not _permanent_state.is_on_floor():
		new_state = FALL
	return new_state
	
func _check_fall_state():
	var new_state = FALL
	if _permanent_state.is_on_floor() and Input.get_axis("move_left", "move_right") == 0:
		new_state = IDLE
	elif _permanent_state.is_on_floor() and Input.get_axis("move_left", "move_right") != 0:
		new_state = WALK
	elif Input.is_action_just_pressed("jump") and (_raycast_left.is_colliding() or _raycast_right.is_colliding()):
		new_state = WALL_JUMP
	elif Input.is_action_just_pressed("jump") and _double_jumps != 0:
		new_state = DOUBLE_JUMP
	elif Input.is_action_just_pressed("dash") and _dashs != 0:
		new_state = DASH
	return new_state
	
func _check_jump_state():
	var new_state = JUMP
	if _permanent_state.velocity.y >= 0:
		new_state = FALL
	elif Input.is_action_just_pressed("jump") \
	and (_raycast_right.is_colliding() or _raycast_left.is_colliding()) \
	and not _permanent_state.is_on_floor():
		new_state = WALL_JUMP
	elif Input.is_action_just_pressed("jump") and _double_jumps != 0:
		new_state = DOUBLE_JUMP
	elif Input.is_action_just_pressed("dash") and _dashs != 0:
		new_state = DASH
	return new_state
	
func _check_double_jump_state():
	var new_state = DOUBLE_JUMP
	if _permanent_state.velocity.y >= 0:
		new_state = FALL
	elif Input.is_action_just_pressed("jump") \
	and (_raycast_right.is_colliding() or _raycast_left.is_colliding()) \
	and not _permanent_state.is_on_floor():
		new_state = WALL_JUMP
	elif Input.is_action_just_pressed("dash") and _dashs != 0:
		new_state = DASH
	return new_state
	
func _check_wall_jump_state():
	var new_state = WALL_JUMP
	if abs(_permanent_state.velocity.x) <= 1 or _permanent_state.velocity.y >= 0:
		new_state = FALL
	elif Input.is_action_just_pressed("dash") and _dashs != 0:
		new_state = DASH
	return new_state
		
func _check_dash_state():
	var new_state = DASH
	if abs(_permanent_state.velocity.x) <= 40 and abs(_permanent_state.velocity.y) <= 40:
		new_state = FALL
	return new_state
	
# help functions
func _apply_gravity(_delta):
	_permanent_state.velocity.y += GRAVITY * _delta
	_permanent_state.velocity.y = min(_permanent_state.velocity.y, GRAVITY_MAX)
	
func _apply_movement():
	if Input.is_action_pressed("move_right"):
		_permanent_state.velocity.x = MOVEMENT_SPEED
		_current_direction = 1
	if Input.is_action_pressed("move_left"):
		_permanent_state.velocity.x = -MOVEMENT_SPEED
		_current_direction = -1

func _apply_lerp_x(weight: float):
	_permanent_state.velocity.x = lerp(_permanent_state.velocity.x, 0.0, weight)
	
func _apply_lerp_y(weight: float):
	_permanent_state.velocity.y = lerp(_permanent_state.velocity.y, 0.0, weight)
	
func _apply_move_and_slide():
	_permanent_state.move_and_slide()
	
func _set_state(new_state):
	_enter_state = new_state != _current_state
	_current_state = new_state

func _reset_attributes():
	_double_jumps = MAX_DOUBLE_JUMPS
	_dashs = MAX_DASHS

func _pull_dash():
	_dashs = max(0, _dashs - 1)
