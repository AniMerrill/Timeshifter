extends KinematicBody2D

# Assigned in Level.gd::spawn_objects()
var player# := get_parent().get_node("Player")
var tilemap# = get_parent().get_node("TileMap")
var astar# = get_parent().astar
var astar_ary# = get_parent().astar_ary

var health := 3

var speed := 4 * Globals.UNIT_SIZE
var move_dir := Vector2.ZERO
var velocity := Vector2.ZERO

var path = []
var should_get_path = true

var has_seen_player := false

var anim_prefix = "s_"
var cur_anim = "idle"

func _ready():
	$Area2D.connect("body_entered", self, "on_collide")
	$Timer.connect("timeout", self, "reset_pathfinding")

func check_for_player() -> void:
	$RayCast2D.look_at(player.global_position)
	
	if $RayCast2D.is_colliding():
		var body = $RayCast2D.get_collider()
		
		has_seen_player = body.is_in_group(Globals.PlayerGroup)

func chase():
	var map_pos = tilemap.world_to_map(global_position)
	var player_map_pos = tilemap.world_to_map(player.global_position)
	var a_pos = -1
	var player_a_pos = -1
	
	if astar_ary.has(str(map_pos)):
		a_pos = astar_ary[str(map_pos)]
	
	if astar_ary.has(str(player_map_pos)):
		player_a_pos = astar_ary[str(player_map_pos)]
	
	var new_path = astar.get_point_path(a_pos, player_a_pos)
	
	if !path.empty():
		if new_path[new_path.size() -1] != path[path.size() -1]:
			path = new_path
			should_get_path = false
			$Timer.start(1)
	else:
		path = new_path
		should_get_path = false
		$Timer.start(1)

func follow_path(delta : float) -> void:
	if !path.empty():
		move_dir = Vector2(
			sign(path[0].x - global_position.x),
			sign(path[0].y - global_position.y)
			)
		
		velocity = move_dir * speed
		
		move_and_slide(velocity)
		
		if abs(global_position.x - path[0].x) < 0.5:
			global_position.x = path[0].x
		if abs(global_position.y - path[0].y) < 0.5:
			global_position.y = path[0].y
		
		if global_position == path[0]:
			path.remove(0)
	else:
		should_get_path = true

func bullet_hit() -> void:
	health -= 1
	
	if health <= 0:
		queue_free()

func on_collide(body : Node) -> void:
	if body.is_in_group(Globals.PlayerGroup):
		body.take_damage()

func reset_pathfinding() -> void:
	should_get_path = true
