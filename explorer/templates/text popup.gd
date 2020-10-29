extends Popup

onready var content = $scroll/content
onready var file_name_label = $title/filename

var text setget set_text
var file_name setget set_file_name

func close():
	hide()

func on_close_pressed():
	close()

func set_text(value):
	content.text = value

func set_file_name(value):
	file_name_label.text = value
