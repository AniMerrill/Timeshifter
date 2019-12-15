extends CanvasLayer

onready var new_btn = $MarginContainer/VBoxContainer/NewGame
onready var how_btn = $MarginContainer/VBoxContainer/HowToPlay
onready var credit_btn = $MarginContainer/VBoxContainer/Credits
onready var quit_btn = $MarginContainer/VBoxContainer/Quit

onready var how_back_btn = $HowToPlay/ColorRect/VBoxContainer/Button
onready var credit_back_btn = $Credits/ColorRect/VBoxContainer/Button

var bgm = preload("res://BGM/GJ_ambient.ogg")

var bgm_start = false

func _ready():
	$Timer.connect("timeout", self, "start_intro")
	$AnimationPlayer.connect("animation_finished", self, "anim_finished")
	
	new_btn.connect("pressed", self, "new_pressed")
	how_btn.connect("pressed", self, "how_pressed")
	credit_btn.connect("pressed", self, "credit_pressed")
	quit_btn.connect("pressed", self, "quit_pressed")
	
	how_back_btn.connect("pressed", self, "how_back_pressed")
	credit_back_btn.connect("pressed", self, "credit_back_pressed")
	
	$AudioStreamPlayer.connect("finished", self, "audio_finished")
	
	$Timer.start(1)
	
	new_btn.grab_focus()
	
	$HowToPlay.visible = false
	$Credits.visible = false

func _input(e):
	if e.is_action_pressed("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen

func start_intro():
	$AnimationPlayer.play("intro")
	$AudioStreamPlayer.play()

func anim_finished(anim):
	if anim == "intro":
		$AnimationPlayer.play("default")

func audio_finished():
	if !bgm_start:
		bgm_start = true
#		$AudioStreamPlayer.stream = bgm
#		#$AudioStreamPlayer.autoplay = true
#		$AudioStreamPlayer.play()

func new_pressed():
	get_tree().change_scene("res://GameMaster.tscn")

func how_pressed():
	$HowToPlay.visible = true
	how_back_btn.grab_focus()

func credit_pressed():
	$Credits.visible = true
	credit_back_btn.grab_focus()

func quit_pressed():
	get_tree().quit()

func how_back_pressed():
	$HowToPlay.visible = false
	how_btn.grab_focus()

func credit_back_pressed():
	$Credits.visible = false
	credit_btn.grab_focus()
