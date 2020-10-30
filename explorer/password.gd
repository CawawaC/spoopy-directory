extends Panel

signal password_entered

func on_player_name_text_entered(new_text):
	if new_text.length() >= 3:
		emit_signal("password_entered", new_text)
		hide()
