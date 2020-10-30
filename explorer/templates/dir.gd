extends Control

onready var label = $vbox/label
onready var actions = $actions 

export var password_locked = false
export var password = ""

var pid
var file_name setget set_dir_name, get_dir_name
var passage

signal opened
signal password_entered
signal ask_for_password

func _ready():
	connect("opened", get_parent(), "on_dir_opened")

func open():
	if password_locked:
		emit_signal("ask_for_password")
	else:
		emit_signal("opened", pid, file_name)

func set_dir_name(value):
	file_name = value
	label.text = value

func get_dir_name():
	return file_name

func on_password_entered(text):
	if passage.tags.has("player_name"):
		Config.player_name = text
		password_locked = false
		print("player name entered: ", text)
	else:
		emit_signal("password_entered", text, text == password)
		password_locked = text != password

func set_dynamic(b, strings):
	label.progressive = b
	label.progressive_sequence = strings
