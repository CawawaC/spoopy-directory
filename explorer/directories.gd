extends Control

export (PackedScene) var directory_template
export (PackedScene) var text_file_template

onready var importer = $"../../../../importer"
onready var converter = $"../../../../converter"

signal dir_opened

func init():
	importer.import()
	
	add_passage_directories()

func add_passage_directories(passage = importer.current_passage):
	var links = importer.get_links()
	for l in links:
		var file = add_file(l.pid)
		file.file_name = l.name

func add_file(pid):
	var type = importer.get_passage_type_width_pid(pid)
	var file
	
	match type:
		importer.FileType.DIRECTORY:
			file = directory_template.instance()
			file.pid = pid
			add_child(file)
		
		importer.FileType.TEXT:
			file = text_file_template.instance()
			file.pid = pid
			add_child(file)
			var text = importer.get_passage_with_pid(pid).text
			file.calls = converter.get_signal_blocks(text)
			text = converter.remove_signal_blocks(text)
			file.text = converter.replace_strings(text)
	
	return file

func display_text_file(passage = importer.current_passage):
	pass

func on_dir_opened(pid):
	emit_signal("dir_opened", importer.get_passage_with_pid(pid))
	
	go_to_dir(pid)

func go_to_dir(pid):
	importer.set_current_passage_with_pid(pid)
	
	if importer.current_passage_type == importer.FileType.DIRECTORY:
		clear()
		add_passage_directories()
	elif importer.current_passage_type == importer.FileType.TEXT:
		display_text_file(importer.current_passage)

func clear():
	for c in get_children():
		c.queue_free()
