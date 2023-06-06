extends Sprite2D

@export var time: float = 0.4

func _ready():
	var tween = get_tree().create_tween()
	tween.tween_method(set_shader_value, 1.0, 0.0, time)
	tween.tween_callback(queue_free)
	
func set_shader_value(value: float):
	material.set_shader_parameter("alpha", value)
