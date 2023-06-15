extends Node2D

@export var self_level: String
@export var next_level: String 

@onready var player = $Player
@onready var shake_camera = $ShakeCamera2D
@onready var enemies = $Enemies
@onready var transitions = $Hud/Transitions

func _ready():
	player.connect("create_instance_requisition", create_instance_requisitions)
	player.connect("trauma_requisition", trauma_requisitions)
	player.connect("death", player_death)
	
	for enemie in enemies.get_children():
		_connect_instance(enemie)
		
	shake_camera.target = player
	var player_last_health = SaveSystem.load_health()
	player.set_health(player_last_health)
	
	transitions.open()
	await transitions.animation_finished
	
	player.start()

func player_death():
	await get_tree().create_timer(2).timeout
	
	transitions.close()
	await transitions.animation_finished
	
	get_tree().change_scene_to_file(self_level)

func create_instance_requisitions(instance):
	_connect_instance(instance)
	call_deferred("add_child", instance)

func trauma_requisitions(trauma: float):
	shake_camera.add_trauma(trauma)

func _completed(_body):
	if next_level:
		var ph = player.get_health()
		SaveSystem.save_health(ph)
		
		transitions.close()
		await transitions.animation_finished
		
		get_tree().change_scene_to_file(next_level)
	else:
		print("terminou")
		

func _connect_instance(instance):
	if instance.has_signal("create_instance_requisition"):
		instance.connect("create_instance_requisition", create_instance_requisitions)
	if instance.has_signal("trauma_requisition"):
		instance.connect("trauma_requisition", trauma_requisitions)
