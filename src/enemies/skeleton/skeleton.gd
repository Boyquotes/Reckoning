extends Enemy

@export var initial_health: int = 100
@export var damage: int = 10

@onready var state_machine = $StateMachine
@onready var animation_player = $AnimationPlayer
@onready var animated_sprite = $AnimatedSprite2D
@onready var look_player_raycast = $LookPlayerRayCast2D
@onready var hit_box = $HitBox

@onready var right_marker = $RightMarker2D
@onready var left_market = $LeftMarker2D2

func _ready():
	state_machine.setup(self, animation_player, look_player_raycast)
	state_machine.connect("change_direction", _change_direction)
	state_machine.start()
	# lembrar de colocar isso na função start
	
	hit_box.setup(damage, self)
	health.max_health = initial_health

# chamado quando hurtbox recebe um dano
func _hited(collider):
	var s = collider.global_position - global_position
	state_machine.current_direction = 1 if s.x > 0 else -1

	state_machine.player_hited()

# chamado quando hurtbox recebe um dano e o personagem morre
func _died():
	state_machine.player_died()
	emit_signal("death")


func _on_limite_check_limite_collided():
	state_machine.current_direction *= -1
	
func _change_direction(new_direiton):
	animated_sprite.flip_h = state_machine.current_direction <= 0
	look_player_raycast.target_position = abs(look_player_raycast.target_position) * new_direiton
	
	if new_direiton == 1:
		hit_box.position = right_marker.position
	else:
		hit_box.position = left_market.position
