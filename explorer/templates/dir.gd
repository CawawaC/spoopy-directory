extends Control

onready var label = $label
onready var actions = $actions 

var pid
var file_name setget set_dir_name, get_dir_name

signal opened

func _ready():
	connect("opened", get_parent(), "on_dir_opened")

func open():
	emit_signal("opened", pid)

func set_dir_name(value):
	file_name = value
	label.text = value

func get_dir_name():
	return file_name
