extends Control

onready var popup = $popup
onready var label = $vbox/label
onready var actions = $actions

var file_name setget set_file_name
var text setget set_text
var pid 
var calls

func open():
	popup.popup()
	for c in calls:
		actions.call(c)

func set_text(value):
	popup.text = value

func set_file_name(value):
	file_name = value
	label.text = value

