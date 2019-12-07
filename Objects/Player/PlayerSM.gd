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
	
	return NULL_STATE

func _enter_state(old_state : int, new_state : int) -> void:
	pass

func _exit_state(new_state : int, old_state : int) -> void:
	pass
