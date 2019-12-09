extends Node2D

var empty_idx := -1

var astar = AStar2D.new()
var astar_ary = {}

func _ready():
	var map_rect = $TileMap.get_used_rect()
	
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


