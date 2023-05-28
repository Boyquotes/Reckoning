extends Node2D

@export var _player_stats: Resource

var _max_health: int

@onready var _LIFEBAR_CONTAINER = $LifeBarContainer
@onready var _PROGRESS_BAR = $LifeBarContainer/LifeBar/ProgressBar
@onready var _PLAYERICON_EYES = $LifeBarContainer/PlayerIcon/Eyes
@onready var _LIFEBAR_SKULL_EYES = $LifeBarContainer/LifeBar/SkullEyes

func _ready():
	_max_health = _player_stats.get_max_health()
	_player_stats.connect("health_changed", _set_value)
	
	_PROGRESS_BAR.max_value = _max_health
	_set_value(_player_stats.get_health())


func _set_value(amount):
	_PROGRESS_BAR.value = amount
	if amount < _max_health * 0.3:
		_set_eyes("sad_eyes")
		_PROGRESS_BAR.get_theme_stylebox("fill").bg_color = Color("f54f4f")
	elif amount < _max_health * 0.5:
		_set_eyes("danger_eyes")
		_PROGRESS_BAR.get_theme_stylebox("fill").bg_color = Color("ff8766")
	else:
		_set_eyes("rage_eyes")
		_PROGRESS_BAR.get_theme_stylebox("fill").bg_color = Color("4c8f82")
		
func _set_eyes(animation: String):
	_PLAYERICON_EYES.play(animation)
	_LIFEBAR_SKULL_EYES.play(animation)
