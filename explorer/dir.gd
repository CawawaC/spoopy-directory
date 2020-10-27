extends Control

onready var label = $label

var pid
var dir_name setget set_dir_name, get_dir_name

signal opened

func _ready():
	connect("opened", get_parent(), "on_dir_opened")

func open():
	emit_signal("opened", pid)

func set_dir_name(value):
	dir_name = value
	label.text = value

func get_dir_name():
	return dir_name
