extends Panel

onready var explorer_root = $margin
onready var titles = $titles

func _ready():
	if not Config.debug_skip_intro:
		explorer_root.modulate.a = 0
		titles.modulate.a = 1
	else:
		explorer_root.modulate.a = 1
		titles.hide()

func quit():
	print("quit")
	get_tree().quit()

func on_close_pressed():
	quit()

func on_titles_intro_ended():
	explorer_root.modulate.a = 1
	titles.modulate.a = 0
	titles.hide()
