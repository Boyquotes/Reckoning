extends CharacterBody2D

signal create_instance_requisition(instance)
signal trauma_requisition(trauma: float)
signal death

@export var _stats: Resource

@onready var _collsion_shape = $CollisionShape2D
@onready var _finite_state_machine = $StateMachine
@onready var _raycast_right = $RayCast2DRight
@onready var _raycast_left = $RayCast2D2Left
@onready var _hurt_box = $HurtBox
@onready var _sword = $Sword

@onready var _player_animated_sprite = $Textures/PlayerAnimatedSprite2D

func _ready():
	_finite_state_machine.setup(self, 
	_raycast_right, _raycast_left, 
	_player_animated_sprite, _sword)
	_hurt_box.setup(self)
	
	
	_finite_state_machine.connect("change_direction", _change_direction)
	_sword.connect("trauma_requisition", trauma_requisitions)
	
# api exterior##################################################################
# aqui deve ser setado a vida que o player deve iniciar
# pois a room irá carregar os dados anteriores
func set_health(health: float):
	_stats.set_health(health)
	
# pega a vida atual, função é chamada pela room quando for salvar os dados
func get_health():
	return _stats.get_health()
	
# aqui deve ser iniciado a rotina normal do player
# ou seja, iniciando a machine state como idle
func start():
	_sword.visible = true
	_finite_state_machine.start()
	_collsion_shape.set_deferred("disabled", false)
################################################################################
	
# api utilizada pelos states ###################################################
func invencible(condition: bool):
	_hurt_box.set_deferred("monitoring", !condition)
	_hurt_box.set_deferred("monitorable", !condition)
	
func create_instance(instance):
	emit_signal("create_instance_requisition", instance)

func trauma_requisitions(trauma: float):
	emit_signal("trauma_requisition", trauma)
################################################################################

# tratamento de dano vindo da hurt box
func _on_hurt_box_collided(damage, collider):
	if not _stats.is_died():
		_stats.take_damage(damage)
		if not _stats.is_died():
			_finite_state_machine.player_hited()
		else:
			_player_death()
	# seta state machine para o estado hited
	# emite sinal de trauma
	# começa periodo de invencibilidade
	
# lembrar de lidar com multiplos sinais de morte do player
func _player_death():
	_sword.visible = false
	_finite_state_machine.player_died()
	_collsion_shape.set_deferred("disabled", true)
	emit_signal("death")


	
# recebe -1 ou 1
func _change_direction(new_direction):
	_player_animated_sprite.flip_h = new_direction <= 0
	_sword.flip_h(new_direction < 0)
	
