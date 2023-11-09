class_name AirState extends State

var has_jump_forgiveness: bool = false
var jump_forgiveness_time: float = 0.1	#seconds
var has_double_jumped: bool = false

var time_elapsed: float = 0

func on_enter() -> void:
	$"../../AnimationTree".set("parameters/ground_air/transition_request", "air_state")
	pass

func state_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("jump"):	
		if has_jump_forgiveness:		#jump with forgiveness (after leaving platform)
			print("forgiven")
			$"../input_check".jump($".", event)
			pass
		elif !has_double_jumped:			#double jump
			double_jump()
	
	$"../input_check".permission_checker($".", event)	#main state changer

func state_process(delta: float) -> void:
	time_elapsed += delta
	if (time_elapsed >= jump_forgiveness_time):
		has_jump_forgiveness = 0
	if can_move:
		movement()		#instead of walking state
	
	#change state
	if character.is_on_floor():
		if character.velocity.x == 0:
			next_state = idle_state			#TO IDLE STATE
		else:
			next_state = walking_state		#TO WALKING STATE
	
	if Input.is_action_pressed(controls.climb) && character.is_on_wall() && !get_parent().just_detached:	#TO CLIMBING STATE
		next_state = climbing_state

func movement() -> void:
	var direction = Input.get_axis(controls.move_left, controls.move_right)
	if direction:
		character.velocity.x = direction * get_parent().MOVING_SPEED
		if $"../..".can_flip_sprite :
			if direction > 0:
				$"../..".is_facing_right = true
			else:
				$"../..".is_facing_right = false
	else:
		character.velocity.x = move_toward(character.velocity.x, 0, 50)	

func double_jump() -> void:
	character.velocity.y = get_parent().DOUBLE_JUMP_VELOCITY
	$"../../AnimationTree".set("parameters/air_state/transition_request", "jump_state")
	$"../../AnimationTree".set("parameters/jump_state/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	has_double_jumped = true

func on_exit() -> void:
	time_elapsed = 0
	if next_state == idle_state || next_state == walking_state:	#reset double jump
		has_double_jumped = false
		$"../../AnimationTree".set("parameters/jump_state/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)
		$"../../AnimationTree".set("parameters/landing/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
