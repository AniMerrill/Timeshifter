extends KinematicBody2D

onready var bullet := preload("res://Objects/Player/Bullet.tscn")

var face_dir := Vector2.RIGHT
var move_dir := Vector2.ZERO
var velocity := Vector2.ZERO

var health := 60.0

var speed := 5 * Globals.UNIT_SIZE
var shot_speed := 10 * Globals.UNIT_SIZE

var i_frame_time := 2.0
var i_frames = false

var cur_anim = "idle"

func _ready() -> void:
	$Timer.connect("timeout", self, "disable_i_frames")

func _input(e : InputEvent) -> void:
	if e.is_action_pressed("shoot_left"):
		face_dir = Vector2.LEFT
		
		$BodyAnim.play("w_" + cur_anim)
		$GunAnim.play("w_shoot")
		
		var inst = bullet.instance()
		inst.velocity = face_dir * shot_speed
		inst.position = $Rig/BulletSpawn.global_position
		inst.rotation_degrees = 180
		get_parent().add_child(inst)
	elif e.is_action_pressed("shoot_right"):
		face_dir = Vector2.RIGHT
		
		$BodyAnim.play("e_" + cur_anim)
		$GunAnim.play("e_shoot")
		
		var inst = bullet.instance()
		inst.velocity = face_dir * shot_speed
		inst.position = $Rig/BulletSpawn.global_position
		get_parent().add_child(inst)
	elif e.is_action_pressed("shoot_up"):
		face_dir = Vector2.UP
		
		$BodyAnim.play("n_" + cur_anim)
		$GunAnim.play("n_shoot")
		
		var inst = bullet.instance()
		inst.velocity = face_dir * shot_speed
		inst.position = $Rig/BulletSpawn.global_position
		inst.rotation_degrees = 90
		get_parent().add_child(inst)
	elif e.is_action_pressed("shoot_down"):
		face_dir = Vector2.DOWN
		
		$BodyAnim.play("s_" + cur_anim)
		$GunAnim.play("s_shoot")
		
		var inst = bullet.instance()
		inst.velocity = face_dir * shot_speed
		inst.position = $Rig/BulletSpawn.global_position
		inst.rotation_degrees = 270
		get_parent().add_child(inst)

func countdown(delta : float) -> void:
	health -= delta

func apply_input() -> void:
	move_dir = Vector2(
		-int(Input.is_action_pressed("move_left")) +\
			int(Input.is_action_pressed("move_right")),
		-int(Input.is_action_pressed("move_up")) +\
			int(Input.is_action_pressed("move_down"))
	)
	
	velocity = move_dir * speed
	
#	if move_dir != Vector2.ZERO:
#		face_dir = move_dir

func apply_movement() -> void:
	move_and_slide(velocity)
	
	#print(abs(velocity.x), abs(velocity.y))

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
	
	label.text = "Time: " + str(int(health)) + "\nVelocity: " + str(velocity)

func disable_i_frames():
	print("iframes stop")
	i_frames = false
