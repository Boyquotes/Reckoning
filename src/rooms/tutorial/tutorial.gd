extends Node2D


@onready var label_current_state = $HUD/LabelCurrentState
@onready var label_double_jumps = $HUD/LabelDoubleJumps
@onready var label_dahs = $HUD/LabelDashs
@onready var machine_state = $Player/PlayerStateMachine

func _process(delta):
	label_double_jumps.text = "Double jumps: " + str(machine_state._double_jumps)
	label_dahs.text = "Dashs: " + str(machine_state._dashs)

func _on_player_state_machine_state_changed(new_signal: String):
	label_current_state.text = "Current state: " + new_signal
