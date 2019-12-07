extends KinematicBody2D

onready var bullet := preload("res://Objects/Player/Bullet.tscn")

var face_dir := Vector2.RIGHT
var move_dir := Vector2.ZERO
var velocity := Vector2.ZERO

var bullet_spwn_offset := 50.0

var health := 60.0

var speed := 5 * Globals.UNIT_SIZE
var shot_speed := 10 * Globals.UNIT_SIZE

var i_frame_time := 2.0
var i_frames = false

func _ready() -> void:
	$Timer.connect("timeout", self, "disable_i_frames")

func _input(e : InputEvent) -> void:
	if e.is_action_pressed("ui_accept"):
		var inst = bullet.instance()
		inst.velocity = face_dir * shot_speed
		inst.position = $BulletSpawn.global_position
		get_parent().add_child(inst)

func countdown(delta : float) -> void:
	health -= delta

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
	
	$BulletSpawn.position = bullet_spwn_offset * face_dir

func apply_movement() -> void:
	velocity = move_and_slide(velocity)

func take_damage():
	if !i_frames:
		health -= 1
		
		if health <= 0:
			print("die")
		else:
			print("iframes start")
			i_frames = true
			$Timer.start()

func update_hud():
	var label = $HUD/MarginContainer/Panel/Label
	
	label.text = "Time: " + str(int(health))

func disable_i_frames():
	print("iframes stop")
	i_frames = false
