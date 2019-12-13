extends StateMachine

func _ready() -> void:
	add_state("idle")
	add_state("walk")
	
	call_deferred("set_state", states.idle)

func _state_logic(delta : float) -> void:
	parent.countdown(delta)
	
	parent.apply_input()
	parent.apply_movement()
	
	parent.update_hud()

func _get_transition(delta : float) -> int:
	match(state):
		states.idle:
			if parent.velocity.x == 0 && parent.velocity.y == 0:
			
				#print(parent.velocity, "idle")
				return states.walk
		states.walk:
			if abs(parent.velocity.x) > 0 || abs(parent.velocity.y) > 0:
				#print(parent.velocity, "walk")
				return states.idle
	
	return NULL_STATE

func _enter_state(old_state : int, new_state : int) -> void:
	var anim_prefix = "e_"
	
	if parent.face_dir == Vector2.LEFT:
		anim_prefix = "w_"
	elif parent.face_dir == Vector2.RIGHT:
		anim_prefix = "e_"
	elif parent.face_dir == Vector2.UP:
		anim_prefix = "n_"
	elif parent.face_dir == Vector2.DOWN:
		anim_prefix = "s_"
	
	match(new_state):
		states.idle:
			parent.cur_anim = "idle"
			parent.get_node("BodyAnim").play(anim_prefix + "idle")
			parent.get_node("GunAnim").play(anim_prefix + "idle")
		states.walk:
			parent.cur_anim = "walk"
			parent.get_node("BodyAnim").play(anim_prefix + "walk")
			parent.get_node("GunAnim").play(anim_prefix + "idle")

func _exit_state(new_state : int, old_state : int) -> void:
	pass
