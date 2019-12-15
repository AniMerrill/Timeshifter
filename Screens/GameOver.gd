extends CanvasLayer

onready var reset = $MarginContainer/VBoxContainer/Button
onready var menu = $MarginContainer/VBoxContainer/Button2
onready var desktop = $MarginContainer/VBoxContainer/Button3

func _ready():
	$VOX.connect("finished", self, "vox_finished")
	
	reset.connect("pressed", self, "reset_game")
	menu.connect("pressed", self, "quit_to_menu")
	desktop.connect("pressed", self, "quit_to_desktop")
	
	reset.disabled = true
	menu.disabled = true
	desktop.disabled = true
	
	$VOX.play()

func vox_finished():
	reset.disabled = false
	menu.disabled = false
	desktop.disabled = false
	
	reset.grab_focus()

func reset_game():
	get_parent().start_new_game()

func quit_to_menu():
	get_tree().paused = false
	get_tree().change_scene("res://Screens/TitleScreen.tscn")

func quit_to_desktop():
	get_tree().quit()
