extends Node2D

@onready var player = $Player
@onready var player_state_machine = $Player/StateMachine
@onready var label_current_state = $HUD/LabelCurrentState
@onready var shake_camera = $ShakeCamera2D
@onready var spawn1 = $Spawns/Spawn1

func _ready():
	player.connect("death", _player_death)
	player.connect("trauma_requisition", _trauma_requisitions)
	player.connect("create_instance_requisition", _create_instance_requistions)
	player_state_machine.connect("transitioned", _player_state_machine_state_transitioned)
	shake_camera.target = player
	_start_player()
	
	

func _player_death():
	await get_tree().create_timer(3).timeout
	_start_player()

func _start_player():
	player.global_position = spawn1.global_position
	player.set_health(100)
	player.start()


func _player_state_machine_state_transitioned(new_signal: String):
	label_current_state.text = new_signal
	
func _trauma_requisitions(trauma: float):
	shake_camera.add_trauma(trauma)

func _create_instance_requistions(instance):
	add_child(instance)
