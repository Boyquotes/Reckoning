extends CharacterBody2D

signal death

@export var _stats: Resource

@onready var _machine_state = $PlayerStateMachine
@onready var _raycast_right = $RayCast2DRight
@onready var _raycast_left = $RayCast2D2Left
@onready var _hurt_box = $HurtBox

func _ready():
	_machine_state.setup(self, _raycast_right, _raycast_left)
	_hurt_box.setup(self)
	
	_stats.connect("death", _player_death)
	
# aqui deve ser setado a vida que o player deve iniciar
# pois a room irá carregar os dados anteriores
func set_health(health: float):
	_stats.set_health(health)
	
# aqui deve ser iniciado a rotina normal do player
# ou seja, iniciando a machine state como idle
func start():
	_machine_state.start()

# tratamento de dano vindo da hurt box
func _on_hurt_box_collided(damage, collider):
	_stats.take_damage(damage)
	
# lembrar de lidar com multiplos sinais de morte do player
func _player_death():
	_machine_state.player_died()
	emit_signal("death")
