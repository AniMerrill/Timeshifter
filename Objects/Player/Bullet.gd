extends Area2D

var velocity := Vector2.ZERO
var damage = 1

func _ready():
	connect("body_entered", self, "on_collide")

func _physics_process(delta):
	position = position + (velocity * delta)

func on_collide(body : Node) -> void:
	if body.is_in_group(Globals.EnemyGroup):
		body.bullet_hit(damage)
	
	queue_free()
