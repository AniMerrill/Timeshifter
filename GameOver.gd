extends CanvasLayer

onready var reset = $MarginContainer/PanelContainer/VBoxContainer/Button

func _ready():
	reset.connect("pressed", self, "reset_game")
	
	reset.grab_focus()

func reset_game():
	get_parent().start_new_game()
