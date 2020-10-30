extends Control

export (PackedScene) var directory_template
export (PackedScene) var text_file_template
export (PackedScene) var directory_password

onready var importer = $"../../../../importer"
onready var converter = $"../../../../converter"

signal dir_opened

func init():
	importer.import()
	
	add_passage_directories()

func add_passage_directories(passage = importer.current_passage):
	var links = importer.get_links(passage)
	for l in links:
		var file = add_file(l.pid)
		l.name = converter.replace_strings(l.name)
		file.file_name = l.name

func add_file(pid):
	var type = importer.get_passage_type_width_pid(pid)
	var passage = importer.get_passage_with_pid(pid)
	var file
	
	match type:
		importer.FileType.DIRECTORY:
			file = directory_template.instance()
			file.pid = pid
			add_child(file)
		
		importer.FileType.DIRECTORY_PASSWORD:
			file = directory_password.instance()
			file.pid = pid
			file.connect("ask_for_password", self, "directory_password_entered")
			add_child(file)
		
		importer.FileType.TEXT:
			file = text_file_template.instance()
			file.pid = pid
			add_child(file)
			
			
			var text = importer.get_passage_with_pid(pid).text
			file.calls = converter.get_signal_blocks(text)
			text = converter.remove_signal_blocks(text)
			text = converter.replace_strings(text)
			file.text = text
	
	file.passage = passage
	
	if passage.has("tags"):
		if passage.tags.has("hidden"):
			file.hide()
		if passage.tags.has("dynamic"):
			var strings = converter.get_progressive_sequence(passage.text)
			file.set_dynamic(true, strings)
	
	return file

func on_dir_opened(pid, dir_name):
	dir_name = converter.replace_strings(dir_name)
	var passage = importer.get_passage_with_pid(pid)
	passage.name = dir_name
	emit_signal("dir_opened", passage)
	
	go_to_dir(pid)

func go_to_dir(pid):
	importer.set_current_passage_with_pid(pid)
	
	if importer.current_passage_type == importer.FileType.DIRECTORY:
		clear()
		add_passage_directories()
#	elif importer.current_passage_type == importer.FileType.TEXT:
#		display_text_file(importer.current_passage)

func clear():
	for c in get_children():
		c.queue_free()

func directory_password_entered(text, valid):
	print("password entered: ", text, ". Valid: ", valid)
