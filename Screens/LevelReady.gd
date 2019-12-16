extends CanvasLayer

var level_number = -1

func _ready():
	$MarginContainer/VBoxContainer/Label.text = "LEVEL " + str(level_number) + "\nREADY!"
	$AudioStreamPlayer.connect("finished", self, "audio_finished")
	$Timer.connect("timeout", self, "start_level")
	
	$Timer.start(2.0)

func audio_finished():
	queue_free()

func start_level():
	get_parent().gameplay = true
	get_tree().paused = false
	$MarginContainer.visible = false
