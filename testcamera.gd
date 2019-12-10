extends Camera2D

var speed = 500

func _ready():
	pass

func _process(delta):
	if Input.is_action_pressed("ui_down"):
		position.y += speed * delta
	elif Input.is_action_pressed("ui_up"):
		position.y -= speed * delta
	elif Input.is_action_pressed("ui_left"):
		position.x -= speed * delta
	elif Input.is_action_pressed("ui_right"):
		position.x += speed * delta
