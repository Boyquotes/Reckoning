extends Node2D

signal animation_finished

@export var damage: float = 20

var attacking = false

var animations = ["attack1", "attack2"]
var current_animation = 0


@onready var sword_sprite = $SwordSprite2D
@onready var animation_player = $AnimationPlayer
@onready var hit_box = $HitBox
@onready var right_marker = $RightMarker2D
@onready var left_market = $LeftMarker2D

func _ready():
	hit_box.global_position = right_marker.global_position
	hit_box.setup(damage, self)

# api ##########################################
func attack():
	if !attacking: 
		animation_player.play(animations[current_animation])
		attacking = true
		_push_animation()


func flip_h(condition: bool) -> void:
	if condition:
		sword_sprite.flip_h = true
		hit_box.global_position = left_market.global_position
	else:
		sword_sprite.flip_h = false
		hit_box.global_position = right_marker.global_position
##################################################

func _push_animation():
	current_animation = (current_animation + 1) % animations.size()

func _on_animation_player_animation_finished(anim_name):
	if attacking:
		attacking = false
		animation_player.play("idle")
		emit_signal("animation_finished")
