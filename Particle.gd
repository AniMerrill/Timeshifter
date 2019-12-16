extends CPUParticles2D


func _ready():
	pass


func _process(delta):
	if !emitting:
		queue_free()
