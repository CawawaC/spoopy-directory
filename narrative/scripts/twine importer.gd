extends Node

enum FileType { DIRECTORY, TEXT, DIRECTORY_PASSWORD, EXECUTABLE }

export (String) var file_path

var twine
var passages
var current_passage
var current_passage_type setget , get_current_passage_type

func import():
	var content = open()
	twine = parse_json(content)
	if twine == null:
		push_error("Could not import json: " + file_path)
		return
	
	passages = twine.passages
	current_passage = get_starting_passage()

func open():
	var file = File.new()
	file.open(file_path, File.READ)
	var content = file.get_as_text()
	file.close()
	return content

func get_passage_with_pid(pid):
	for p in passages:
		if p.pid == pid:
			return p

func get_starting_passage():
	return get_passage_with_pid(twine.startnode)

func get_links(passage = current_passage):
	if "links" in passage:
		return passage.links
	else:
		return []

func set_current_passage_with_pid(pid):
	current_passage = get_passage_with_pid(pid)

func get_passage_type_width_pid(pid):
	var p = get_passage_with_pid(pid)
	return get_passage_type(p)

func get_passage_type(passage):
	if passage == null:
		return null
	
	if not passage.has("tags"):
		return FileType.DIRECTORY
	
	if passage.tags.has("text"):
		return FileType.TEXT
	elif passage.tags.has("password"):
		return FileType.DIRECTORY_PASSWORD
	elif passage.tags.has("executable"):
		return FileType.EXECUTABLE
	else:
		return FileType.DIRECTORY

func get_current_passage_type():
	return get_passage_type(current_passage)

func get_next_passage():
	if current_passage.has("links"):
		var pid = current_passage.links[0].pid
		return get_passage_with_pid(pid)
	return null
