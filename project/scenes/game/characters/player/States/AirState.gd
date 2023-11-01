extends State

class_name AirState

var has_double_jumped : bool = false

func on_enter():
	$"../../AnimationTree".set("parameters/ground_air/transition_request", "air_state")
	pass


func state_input(event: InputEvent):
	
	if(Input.is_action_just_pressed("jump")):	#double jump
		if(not has_double_jumped):
			double_jump()
	
	$"../input_check".permission_checker($".", event)	#main state changer


func state_process(delta):
	if(can_move):
		movement()		#instead of walking state
	
	#change state
	if(character.is_on_floor()):
		if(character.velocity.x == 0):
			next_state = idle_state			#TO IDLE STATE
		else:
			next_state = walking_state		#TO WALKING STATE
	
	if(Input.is_action_pressed("climb") and character.is_on_wall() and not get_parent().just_detached):	#TO CLIMBING STATE
		next_state = climbing_state


func movement():
	var direction = Input.get_axis("left", "right")
	if direction:
		character.velocity.x = direction* get_parent().MOVING_SPEED	
	else:
		character.velocity.x = move_toward(character.velocity.x, 0, 50)	

func double_jump():
	character.velocity.y = get_parent().DOUBLE_JUMP_VELOCITY
	$"../../AnimationTree".set("parameters/jump_state/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	has_double_jumped = true

	
func on_exit():
	if(next_state == idle_state or next_state == walking_state):	#reset double jump
		has_double_jumped = false
		$"../../AnimationTree".set("parameters/jump_state/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)
