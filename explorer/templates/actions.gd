extends Node

func display_parent_button():
	$"../../../../parent".show()

func key1_opened():
	Config.key1_opened = true
