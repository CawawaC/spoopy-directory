extends Node

export (String, MULTILINE) var test_text

func clean_up(text):
	text = replace_strings(text)
	text = remove_signal_blocks(text)
	text = remove_response_blocks(text)
	return text

func replace_strings(text):
	text = text.replace("==player==", Config.player_name)
	text = text.replace("==player_short==", Config.player_name_short)
	return text

func get_signals(text):
	var regex = RegEx.new()
	regex.compile("\\+\\+(.+?)\\+\\+")
	var result = regex.search_all(text)
	return result

func get_signal_blocks(text):
	var result = get_signals(text)
	var strings = []
	for r in result:
		strings.append(r.strings[1])
	return strings

func remove_signal_blocks(text):
	var result = get_signals(text)
	for r in result:
		text = text.replace(r.strings[0], "")
	return text

func remove_response_blocks(text):
	var regex = RegEx.new()
	regex.compile("\\[\\[(.+)\\]\\]")
	var result = regex.sub(text, "")
	return result
	return text

func get_progressive_sequence(text):
	var a = text.split("___\n")
	return a

func test():
	var signals = get_signal_blocks(test_text)
	for s in signals:
		emit_signal(s)

func is_condition_true(tags):
	for t in tags:
		if t.begins_with("if:"):
			var condition = t.substr(3)
			var b = Config.get(condition)
			return b
	return true

func get_conditions(tags):
	for t in tags:
		if t.begins_with("if:"):
			var condition = t.substr(3)
			var b = Config.get(condition)
			print(b)
