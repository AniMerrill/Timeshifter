extends StateMachine

func _ready():
	add_state('idle')
	add_state('chase')
	add_state('knockback')
	add_state('death')
	
	call_deferred("set_state", states.idle)

func _state_logic(delta : float) -> void:
	parent.check_for_player()
	
	if state == states.chase:
		if parent.should_get_path && parent.has_seen_player:
			parent.chase()
		
		parent.follow_path(delta)

func _get_transition(delta : float) -> int:
	match(state):
		states.idle:
			if parent.has_seen_player:
				return states.chase
		states.chase:
			if !parent.has_seen_player && parent.path.empty():
				return states.idle
	
	return NULL_STATE

func _enter_state(old_state : int, new_state : int) -> void:
	pass

func _exit_state(new_state : int, old_state : int) -> void:
	pass
