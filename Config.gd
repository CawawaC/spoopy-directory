extends Node

var debug = false
var debug_skip_intro = true

var player_name = "Stéphane de Lamargé"
var player_name_short = "Stéphane"
var show_hidden_files = false

var key1_opened = false
var key1_not_opened setget , get_key1_not_opened

func get_key1_not_opened():
	return not key1_opened
