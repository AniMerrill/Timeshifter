extends Node2D

onready var player = preload("res://Objects/Player/Player.tscn")
onready var enemy = preload("res://Objects/Enemy/Enemy.tscn")

var empty_idx := 1

var room_size := Vector2(10,10)
var room_count := 10
var room_array = []

var enemy_count = 20

var astar = AStar2D.new()
var astar_ary = {}

var map_rect
var map_seed = -1

func _ready():
	seed(get_random_seed())
	
	print(map_seed)
	
	map_generation()
	astar_generation()
	spawn_objects()

func get_random_seed(preset : int = -1):
	if preset == -1:
		randomize()
		map_seed = randi()
		return map_seed
	else:
		map_seed = preset
		return map_seed

func map_generation():
	for z in range(room_count):
		var offset_x = 0
		var offset_y = 0
		
		var new_room = Vector2.ZERO
		var prev_room = null
		
		if z == 0:
			room_array.append(Vector2.ZERO)
		else:
			while room_array.has(new_room):
				prev_room = room_array[randi() % room_array.size()]
				
				var rand_offset = 0
				
				match(randi() % 2):
					0:
						rand_offset = -1
					1:
						rand_offset = 1
				
				match(randi() % 2):
					0:
						new_room = Vector2(
							prev_room.x + (rand_offset),
							prev_room.y
						)
					1:
						new_room = Vector2(
							prev_room.x,
							prev_room.y + (rand_offset)
						)
			
			room_array.append(new_room)
			
			offset_x = new_room.x
			offset_y = new_room.y
		
		for y in range(room_size.y):
			for x in range(room_size.x):
				var cell_x = (x - room_size.x / 2) + (offset_x * (room_size.x + 2))
				var cell_y = (y - room_size.y / 2) + (offset_y * (room_size.y + 2))
					
				if x == 0 || y == 0 || \
				x == room_size.x -1 || y == room_size.y - 1:
					$TileMap.set_cell(cell_x, cell_y, 0)
				else:
					$TileMap.set_cell(cell_x, cell_y, 1)
					# TODO: Make a list of rooms as they're being
					# generated and add an array of floor tiles added
					# to that room so enemies/obstacles/player can be
					# spawned per room instead of totally arbitrarily
		
		if prev_room != null:
			var hallway_size = int(rand_range(4, room_size.x))
			var hallway = Vector2.ZERO
			
			if abs(offset_x - prev_room.x) == 1:
				hallway = Vector2(4, hallway_size)
			
			if abs(offset_y - prev_room.y) == 1:
				hallway = Vector2(hallway_size, 4)
			
			for y in range(hallway.y):
				for x in range(hallway.x):
					var cell_x = (x - hallway.x / 2) + (prev_room.x * (room_size.x + 2)) + ((offset_x - prev_room.x) * (room_size.x / 2 + 1))
					var cell_y = (y - hallway.y / 2) + (prev_room.y * (room_size.y + 2)) + ((offset_y - prev_room.y) * (room_size.y / 2 + 1))
					
					if abs(offset_x - prev_room.x) == 1:
						if y == 0 || y == hallway.y - 1:
							$TileMap.set_cell(cell_x, cell_y, 0)
						else:
							$TileMap.set_cell(cell_x, cell_y, 1)
					if abs(offset_y - prev_room.y) == 1:
						if x == 0 || x == hallway.x - 1:
							$TileMap.set_cell(cell_x, cell_y, 0)
						else:
							$TileMap.set_cell(cell_x, cell_y, 1)
	
	map_rect = $TileMap.get_used_rect()
	
	for cell_y in range(map_rect.position.y,
						map_rect.position.y + map_rect.size.y
	):
		for cell_x in range(map_rect.position.x,
							map_rect.position.x + map_rect.size.x
		):
			var non_fill = [0, 1]
			if !non_fill.has($TileMap.get_cell(cell_x, cell_y)):
				$TileMap.set_cell(cell_x, cell_y, 0)

func astar_generation() -> void:
	var astar_idx = 0
	
	for cell_y in range(map_rect.position.y, 
						map_rect.position.y + map_rect.size.y
	):
		for cell_x in range(map_rect.position.x, 
							map_rect.position.x + map_rect.size.x
		):
			if $TileMap.get_cell(cell_x, cell_y) == empty_idx:
				#astar_ary[str(cell_x)][str(cell_y)] = astar_idx
				
				astar_ary[str(Vector2(cell_x, cell_y))] = astar_idx
				
				var point_position = $TileMap.map_to_world(
										Vector2(cell_x, cell_y)
									)
				
				point_position.x += $TileMap.cell_size.x / 2
				point_position.y += $TileMap.cell_size.y / 2
				
				#print(astar_idx, point_position)
				
				astar.add_point(astar_idx, point_position)
				
				var up_cell = Vector2(cell_x, cell_y -1)
				var left_cell =Vector2(cell_x -1, cell_y)
				
				if astar_ary.has(str(up_cell)):
					astar.connect_points(
						astar_idx,
						astar_ary[str(up_cell)],
						true
						)
				
				if astar_ary.has(str(left_cell)):
					astar.connect_points(
						astar_idx,
						astar_ary[str(left_cell)],
						true
						)
				
				astar_idx += 1

func spawn_objects():
	var floor_tiles = $TileMap.get_used_cells_by_id(empty_idx)
	var spawn_tile = floor_tiles[randi() % floor_tiles.size()]
	
	floor_tiles.remove(floor_tiles.find(spawn_tile))
	
	var p = player.instance()
	
	p.position = $TileMap.map_to_world(spawn_tile) + ($TileMap.cell_size / 2)
	
	print(map_rect)
	
	p.get_node("Camera2D").limit_left = map_rect.position.x * $TileMap.cell_size.x
	p.get_node("Camera2D").limit_right = map_rect.end.x * $TileMap.cell_size.x
	p.get_node("Camera2D").limit_top = map_rect.position.y * $TileMap.cell_size.y
	p.get_node("Camera2D").limit_bottom = map_rect.end.y * $TileMap.cell_size.y
	
	add_child(p)
	
	for i in range(enemy_count):
		var e = enemy.instance()
		
		e.player = p
		e.tilemap = $TileMap
		e.astar = astar
		e.astar_ary = astar_ary
		
		spawn_tile = floor_tiles[randi() % floor_tiles.size()]
		floor_tiles.remove(floor_tiles.find(spawn_tile))
		
		e.position = $TileMap.map_to_world(spawn_tile) + ($TileMap.cell_size / 2)
		
		add_child(e)
