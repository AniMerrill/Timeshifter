# Based off of the State Machine tutorial by Game Endeavor
# https://www.youtube.com/watch?v=BNU8xNRk_oU
# License TBD

extends Node
class_name StateMachine

const NULL_STATE : int = -1

var state := NULL_STATE setget set_state
var prev_state := NULL_STATE

var states = {}

# warning-ignore:unused_class_variable
onready var parent := get_parent()

# Obviously this State Machine code is intended to be used on the physics
# frame so mostly for the Player, Enemies, etc. as it is currently written.
func _physics_process(delta : float) -> void:
	if state != NULL_STATE:
		_state_logic(delta)
	
	var transition = _get_transition(delta)
	
	if transition != NULL_STATE:
		set_state(transition)

# Virtual Function, essentially replaces the primary _process() function of a
# normal character controller by calling functions from the parent object.
# warning-ignore:unused_argument
func _state_logic(delta : float) -> void:
	pass

# Virtual Function, intended to contain all the conditional logic for changing
# over from one state to another and then either returning the NULL_STATE or
# whichever state should be changed to.
# warning-ignore:unused_argument
func _get_transition(delta : float) -> int:
	return NULL_STATE

# Virtual Function, will take care of postprocessing when transitioning out
# of an old state
# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _exit_state(old_state : int, new_state : int) -> void:
	pass

# Virtual Function, will take care of preprocessing when transitioning into a
# a new state; great for queueing new animations.
# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _enter_state(new_state : int, old_state : int) -> void:
	pass

# Handles the changeover of any state transition
func set_state(new_state :int) -> void:
	prev_state = state
	state = new_state
	
	if prev_state != NULL_STATE:
		_exit_state(prev_state, new_state)
	
	if new_state != NULL_STATE:
		_enter_state(new_state, prev_state)

# Should be called in the extended State Machine's _ready() function to create
# the list of valid states for it. Essentially creates a dynamic enum that can
# be instantiated at runtime with incremental integer values, but also allows
# a list to be obtained and (as in the function below) a display friendly name
# to display in debug information.
func add_state(state_name : String) -> void:
	states[state_name] = states.size()

# Largely for the purpose of debug displays and output
func get_current_state() -> Array:
	for key in states.keys():
		if states[key] == state:
			return [key, state]
	
	return ["null", NULL_STATE]
