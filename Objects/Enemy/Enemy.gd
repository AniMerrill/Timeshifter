extends KinematicBody2D

var health := 3

func _ready():
	$Area2D.connect("body_entered", self, "on_collide")

func bullet_hit() -> void:
	health -= 1
	
	if health <= 0:
		queue_free()

func on_collide(body : Node) -> void:
	if body.is_in_group(Globals.PlayerGroup):
		body.take_damage()
