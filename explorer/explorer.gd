extends Control

onready var importer = $"../../importer"
onready var current_folder = $folder
onready var grid = $scroll/grid

var directory_history = []

func _ready():
	if not Config.debug:
		$parent.hide()

func go_to_parent_directory():
	if directory_history.size() == 0:
		return
	
	var parent_dir = directory_history.back()
	if parent_dir == null:
		return
	
	grid.go_to_dir(parent_dir.pid)
	current_folder.text = parent_dir.name
	directory_history.pop_back()

func on_parent_pressed():
	go_to_parent_directory()

func on_grid_dir_opened(passage):
	directory_history.append(importer.current_passage)
	current_folder.text = passage.name
