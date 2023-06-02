extends Node2D

@onready var player = $Player
@onready var player_state_machine = $Player/StateMachine
@onready var label_current_state = $HUD/LabelCurrentState

@onready var spawn1 = $Spawns/Spawn1

func _ready():
	player.connect("death", _player_death)
	player_state_machine.connect("transitioned", _player_state_machine_state_transitioned)
	_reset_player()

func _player_state_machine_state_transitioned(new_signal: String):
	label_current_state.text = new_signal

func _player_death():
	await get_tree().create_timer(1).timeout
	_reset_player()


func _reset_player():
	player.global_position = spawn1.global_position
	player.set_health(100)
	player.start()
