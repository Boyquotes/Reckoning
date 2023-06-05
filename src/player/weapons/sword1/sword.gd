extends Node2D

signal attack_animation_finished
signal trauma_requisition(trauma: float)

@export var damage: float = 20
@export var trauma: float = 0.15
var reset_animation_time = 0.5

var attacking = false

var animations = ["attack1", "attack2"]
var current_animation = 0


@onready var sword_sprite = $SwordSprite2D
@onready var animation_player = $AnimationPlayer
@onready var hit_box = $HitBox
@onready var right_marker = $RightMarker2D
@onready var left_market = $LeftMarker2D
@onready var reset_animation_timer = $ResetAnimationTimer

func _ready():
	hit_box.position = right_marker.position
	hit_box.setup(damage, self)

# api ##########################################
func attack() -> void:
	if !attacking: 
		animation_player.play(animations[current_animation])
		reset_animation_timer.stop()
		attacking = true
		emit_signal("trauma_requisition", trauma)
		
func cancel_attack() -> void:
	animation_player.play("idle")
	reset_animation_timer.start(-1)
	attacking = false
	
func flip_h(condition: bool) -> void:
	if condition:
		sword_sprite.flip_h = true
		hit_box.position = left_market.position
	else:
		sword_sprite.flip_h = false
		hit_box.position = right_marker.position
##################################################

func _push_animation():
	current_animation = (current_animation + 1) % animations.size()

func _on_hit_box_collided(collider):
	_push_animation()

func _on_animation_player_animation_finished(anim_name):
	if attacking:
		attacking = false
		animation_player.play("idle")
		reset_animation_timer.start(reset_animation_time)
		emit_signal("attack_animation_finished")

func _on_reset_animation_timer_timeout():
	current_animation = 0
