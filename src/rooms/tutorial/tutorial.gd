extends Node2D

@onready var player = $Player
@onready var label_current_state = $HUD/LabelCurrentState
@onready var label_double_jumps = $HUD/LabelDoubleJumps
@onready var label_dahs = $HUD/LabelDashs
@onready var machine_state = $Player/PlayerStateMachine

@onready var spawn1 = $Spawns/Spawn1

var states = {
	0: "idle",
	1: "walk",
	2: "fall",
	3: "jump",
	4: "double jump",
	5: "wall jump",
	6: "dash",
	7: "stopped",
	8: "death"
}

func _ready():
	player.connect("death", _player_death)
	_reset_player()

func _process(delta):
	label_current_state.text = "Current State: " + states[machine_state._current_state]
	label_double_jumps.text = "Double jumps: " + str(machine_state._double_jumps)
	label_dahs.text = "Dashs: " + str(machine_state._dashs)

func _on_player_state_machine_state_changed(new_signal: String):
	label_current_state.text = "Current state: " + new_signal

func _player_death():
	await get_tree().create_timer(1).timeout
	_reset_player()


func _reset_player():
	player.global_position = spawn1.global_position
	player.reset()
	player.set_health(100)
	player.start()
