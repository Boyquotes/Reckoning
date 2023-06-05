extends Enemy

const GRAVITY = 400
const GRAVITY_MAX = 500
const _hited_time = 0.4
const _death_time = 1

@export var flip_h: bool = true

@onready var dummy_tiled = $DummyTiled
@onready var animation_player = $AnimationPlayer
@onready var hited_timer = $HitedTimer

func _ready():
	_set_flip_h(flip_h)
	animation_player.play("idle")

func _physics_process(delta):
	_apply_gravity(delta)
	move_and_slide()
	
func _apply_gravity(_delta):
	velocity.y += GRAVITY * _delta
	velocity.y = min(velocity.y, GRAVITY_MAX)

func _set_flip_h(condition: bool):
	dummy_tiled.flip_h = condition
	
# api vindo de enemy
func _hited():
	animation_player.play("hited")
	hited_timer.stop()
	hited_timer.start(_hited_time)
	
func _died():
	hited_timer.stop()
	animation_player.play("death")
	emit_signal("death")
	
	await get_tree().create_timer(_death_time).timeout
	queue_free()
########################
func _on_hited_timer_timeout():
	animation_player.play("idle")
