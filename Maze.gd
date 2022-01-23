extends Node3D

const N := 1
const E := 2
const S := 4
const W := 8

var cell_walls := {Vector2i(0, -1): N, Vector2i(1, 0): E,
Vector2i(0, 1): S, Vector2i(-1, 0): W}

var tile_size = 64
var width := 50
var height := 50

@onready var Map = $Map

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	tile_size = Map.segment_scale
	make_maze()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func check_neighbors(cell: Vector2i, unvisited: Array[Vector2i]) -> Array[Vector2i]:
	var list: Array[Vector2i] = []
	for n in cell_walls.keys():
		if cell + n in unvisited:
			list.append(cell + n)
	return list

func make_maze() -> void:
	var unvisited: Array[Vector2i] = []
	var stack: Array[Vector2i] = []
	Map.clear()
	for x in range(width):
		for y in range(height):
			unvisited.append(Vector2i(x, y))
			Map.set_cellv(Vector2i(x, y), N|E|S|W)
	var current := Vector2i(0, 0)
	unvisited.erase(current)
	while unvisited:
		var neighbors = check_neighbors(current, unvisited)
		if neighbors.size() > 0:
			var next: Vector2i = neighbors[randi() % neighbors.size()]
			stack.append(current)
			var dir: Vector2i = next - current
			var current_walls: int = Map.get_cellv(current) - cell_walls[dir]
			var next_walls: int = Map.get_cellv(next) - cell_walls[-dir]
			Map.set_cellv(current, current_walls)
			Map.set_cellv(next, next_walls)
			current = next
			unvisited.erase(current)
		elif stack:
			current = stack.pop_back()
	$Player.translate(Vector3(1, 0.2, 1))
