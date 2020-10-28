extends Popup

onready var content = $scroll/content

var text setget set_text

func close():
	hide()

func on_close_pressed():
	close()

func set_text(value):
	content.text = value
