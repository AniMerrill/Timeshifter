extends Area2D

onready var gibs = preload("res://Gibs.tscn")

var velocity := Vector2.ZERO
var damage = 1

func _ready():
	connect("body_entered", self, "on_collide")

func _physics_process(delta):
	position = position + (velocity * delta)

func on_collide(body : Node) -> void:
	if body.is_in_group(Globals.EnemyGroup):
		body.bullet_hit(damage)
	
	var inst = gibs.instance()
	
	inst.position = global_position
	inst.texture = null
	inst.modulate = Color(0.69, 0.94, 0.38, 1)
	inst.emitting = true
	
	get_parent().add_child(inst)
	
	queue_free()
