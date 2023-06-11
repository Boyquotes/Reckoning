extends State
class_name StateSkeleton

const GRAVITY = 400
const GRAVITY_MAX = 500
const MOVEMENT_LERP_WEIGHT = 0.2
const ATTACK_DISTANCE = 10

var animation_player: AnimationPlayer
var look_player_raycast: RayCast2D

func setup(_state_machine, _persistent_state,
	_animation_player: AnimationPlayer,
	_look_player_raycast: RayCast2D):
		
	self.state_machine = _state_machine
	self.persistent_state = _persistent_state
	self.animation_player = _animation_player
	self.look_player_raycast = _look_player_raycast
	
func _apply_movement(_movement_speed):
	persistent_state.velocity.x = _movement_speed * state_machine.current_direction
