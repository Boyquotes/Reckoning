extends CharacterBody2D

@export var stats: Resource

@onready var _machine_state = $PlayerStateMachine
@onready var _raycast_right = $RayCast2DRight
@onready var _raycast_left = $RayCast2D2Left

func _ready():
	stats.reset()
	_machine_state.setup(self, _raycast_right, _raycast_left)

func _input(event):
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_K:
			stats.take_damage(10)
