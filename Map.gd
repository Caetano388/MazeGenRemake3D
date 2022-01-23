class_name Map
extends Node

const N := 1
const E := 2
const S := 4
const W := 8

const HORIZONTAL_WALL := Vector3(1, 1, 0.2)
const VERTICAL_WALL := Vector3(0.2, 1, 1)

var offsets := {N: Vector2(0, -1), E: Vector2(1, 0),
S: Vector2(0, 1), W: Vector2(-1, 0)}

var cells : Dictionary = {}
var tiles : Dictionary = {}

@export var segment_scale : int = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func clear() -> void:
	for child in get_children():
		remove_child(child)

func set_cellv(location: Vector2i, tile_id: int) -> void:
	var translation: Vector2 = location * segment_scale
	var current_tile = CSGCombiner3D.new()
	
	if tiles.has(location):
		remove_child(tiles[location])
	if tile_id & N:
		place_wall(translation + (offsets[N] * segment_scale / 2), false, current_tile)
	if tile_id & E:
		place_wall(translation + (offsets[E] * segment_scale / 2), true, current_tile)
	if tile_id & S:
		place_wall(translation + (offsets[S] * segment_scale / 2), false, current_tile)
	if tile_id & W:
		place_wall(translation + (offsets[W] * segment_scale / 2), true, current_tile)
	cells[location] = tile_id
	var floor = CSGBox3D.new()
	floor.set_size(Vector3(1, 0.1, 1))
	floor.translate(Vector3(translation.x, 0, translation.y) * segment_scale / 2)
	current_tile.add_child(floor)
	add_child(current_tile)
	tiles[location] = current_tile

func place_wall(translation: Vector2, is_vertical: bool, current_tile: CSGCombiner3D) -> void:
	var n_seg := CSGBox3D.new()
	n_seg.translate(Vector3(translation.x, 0.5, translation.y))
	if is_vertical:
		n_seg.set_size(VERTICAL_WALL)
	else:
		n_seg.set_size(HORIZONTAL_WALL)
	current_tile.add_child(n_seg)

func get_cellv(location: Vector2i) -> int:
	return cells[location]
