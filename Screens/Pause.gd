extends CanvasLayer

onready var resume = $MarginContainer/VBoxContainer/Button
onready var menu = $MarginContainer/VBoxContainer/Button2
onready var desktop = $MarginContainer/VBoxContainer/Button3

func _ready():
	resume.connect("pressed", self, "resume_game")
	menu.connect("pressed", self, "quit_to_menu")
	desktop.connect("pressed", self, "quit_to_desktop")
	
	resume.grab_focus()

func _input(e):
	if e.is_action_pressed("pause"):
		resume_game()

func resume_game():
	get_tree().paused = false
	queue_free()

func quit_to_menu():
	get_tree().paused = false
	get_tree().change_scene("res://Screens/TitleScreen.tscn")

func quit_to_desktop():
	get_tree().quit()
