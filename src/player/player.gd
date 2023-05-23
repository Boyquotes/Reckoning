extends CharacterBody2D


@onready var _machine_state = $PlayerStateMachine
@onready var _raycast_right = $RayCast2DRight
@onready var _raycast_left = $RayCast2D2Left

func _ready():
	_machine_state.setup(self, _raycast_right, _raycast_left)
