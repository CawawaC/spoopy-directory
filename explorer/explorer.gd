extends Control

export (PackedScene) var directory_template

onready var importer = $"../importer"

func init():
	importer.import()
	
	add_passage_directories()

func add_passage_directories(passage = importer.current_passage):
	var links = importer.get_links()
	for l in links:
		var dir = add_directory(l.pid)
		dir.dir_name = l.name

func add_directory(pid):
	var dir = directory_template.instance()
	dir.pid = pid
	add_child(dir)
	return dir

func on_dir_opened(pid):
	clear()
	importer.set_current_passage_with_pid(pid)
	add_passage_directories()

func clear():
	for c in get_children():
		c.queue_free()
