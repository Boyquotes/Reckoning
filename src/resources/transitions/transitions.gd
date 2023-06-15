extends ColorRect

signal animation_finished(anim_name: String)

@onready var animation_player = $AnimationPlayer

func open():
	animation_player.play("open")
	
func close():
	animation_player.play("close")


func _on_animation_player_animation_finished(anim_name):
	emit_signal("animation_finished", anim_name)
