extends Node2D

func _ready():
	$Items.hide()
	$Player.reset($SpawnPoint.position)
	set_camera_limits()
	spawn_items()
	
func set_camera_limits():
	var map_size = $World.get_used_rect()
	var cell_size = $World.tile_set.tile_size
	$Player/Camera2D.limit_left = (map_size.position.x - 5) * cell_size.x
	$Player/Camera2D.limit_right = (map_size.end.x + 5) * cell_size.x
	
signal score_changed
var score = 0 : set = set_score

func set_score(value):
	score = value
	score_changed.emit(score)
	
var item_scene = load("res://items/item.tscn")

func spawn_items():
	var item_cells = $Items.get_used_cells()
	for cell in item_cells:
		var data = $Items.get_cell_tile_data(cell)
		var type = data.get_custom_data("type")
		var item = item_scene.instantiate()
		add_child(item)
		item.init(type, $Items.map_to_local(cell))
		item.picked_up.connect(self._on_item_picked_up)
	
func _on_item_picked_up():
	score += 1
