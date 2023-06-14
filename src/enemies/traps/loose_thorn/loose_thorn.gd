extends CharacterBody2D

signal trauma_requisition(trauma: float)

@export var damage: float

const GRAVITY = 600
const MAX_GRAVITY = 700
const DEATH_TIME = 0.5
const TRAUMA = 0.1

var death = false

@onready var animated_sprite = $AnimatedSprite2D
@onready var death_timer = $DeathTimer
@onready var hit_box = $HitBox


# api ###############################################
func setup(damage: float):
	self.damage = damage
####################################################


func _ready():
	animated_sprite.play("idle")
	hit_box.setup(damage, self)
	
func _physics_process(delta):
	if !death:
		velocity.y += GRAVITY * delta
		velocity.y = min(velocity.y, MAX_GRAVITY)
		move_and_slide()
		if get_slide_collision_count() > 0:
			animated_sprite.play("death")
			death_timer.start(DEATH_TIME)
			hit_box.set_deferred("monitoring", false)
			hit_box.set_deferred("monitorable", false)
			emit_signal("trauma_requisition", TRAUMA)
			set_physics_process(false)
			death = true


func _on_timer_timeout():
	queue_free()
