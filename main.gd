extends Panel

func quit():
	print("quit")
	get_tree().quit()

func on_close_pressed():
	quit()
