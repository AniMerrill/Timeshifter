extends KinematicBody2D

var face_dir := Vector2.ZERO
var move_dir := Vector2.ZERO
var velocity := Vector2.ZERO

var speed := 5 * Globals.UNIT_SIZE

func apply_input() -> void:
	move_dir = Vector2(
		-int(Input.is_action_pressed("ui_left")) +\
			int(Input.is_action_pressed("ui_right")),
		-int(Input.is_action_pressed("ui_up")) +\
			int(Input.is_action_pressed("ui_down"))
	)
	
	velocity = move_dir * speed
	
	if move_dir != Vector2.ZERO:
		face_dir = move_dir

func apply_movement() -> void:
	
	velocity = move_and_slide(velocity)
