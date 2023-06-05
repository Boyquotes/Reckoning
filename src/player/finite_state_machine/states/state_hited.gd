extends State
class_name HitedState

const HITED_TRAUMA = 0.18
const hited_time = 0.5
var timer_hited_animation_finish: Timer


func _ready():
	timer_hited_animation_finish = Timer.new()
	timer_hited_animation_finish.connect("timeout", _on_hited_animation_finish)
	add_child(timer_hited_animation_finish)

func handle_input(_event: InputEvent):
	pass
	
func update(_delta):
	pass
	
func physics_update(_delta):
	persistent_state.velocity = Vector2.ZERO
	_apply_move_and_slide()
	
func enter(_msg = {}):
	persistent_state.invencible(true)
	state_machine.trauma_requisiton(HITED_TRAUMA)
	player_animated_sprite.play("hited")
	timer_hited_animation_finish.start(hited_time)
	
func exit():
	persistent_state.invencible(false)
	timer_hited_animation_finish.stop()
	
func _on_hited_animation_finish():
	if persistent_state.is_on_floor():
		state_machine.transition_to("IdleState")
	elif !persistent_state.is_on_floor():
		state_machine.transition_to("FallState")


