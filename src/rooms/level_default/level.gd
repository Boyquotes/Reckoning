extends Node2D

@export var self_level: String
@export var next_level: String 

@onready var player = $Player
@onready var shake_camera = $ShakeCamera2D
@onready var enemies = $Enemies

func _ready():
	player.connect("create_instance_requisition", create_instance_requisitions)
	player.connect("trauma_requisition", trauma_requisitions)
	player.connect("death", player_death)
	
	for enemie in enemies.get_children():
		enemie.connect("create_instance_requisition", create_instance_requisitions)
		enemie.connect("trauma_requisition", trauma_requisitions)
		enemie.connect("death", enemy_death)
		
	shake_camera.target = player
	var player_health = SaveSystem.load_health()
	player.set_health(player_health)
	player.start()

func player_death():
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_file(self_level)
	
func enemy_death():
	pass

func create_instance_requisitions(instance):
	add_child(instance)

func trauma_requisitions(trauma: float):
	shake_camera.add_trauma(trauma)


func completed(_body):
	if next_level:
		var ph = player.get_health()
		SaveSystem.save_health(ph)
		get_tree().change_scene_to_file(next_level)
	else:
		print("terminou")
