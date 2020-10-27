extends Node

export (String) var file_path

var twine
var passages
var current_passage

func import():
	var content = open()
	twine = parse_json(content)
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
