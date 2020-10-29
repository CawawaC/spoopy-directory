extends Panel

onready var importer = $importer
onready var converter = $converter
onready var label = $title

var period = 0.02
var t = 0

var inactive_period = 2
var inactive_time = 0

signal intro_ended

func _ready():
	importer.import()
	display_passage()

func display_passage():
	var text = converter.clean_up(importer.current_passage.text)
	label.text = text
	label.visible_characters = 0

func _process(delta):
	if importer.current_passage == null:
		return
	
	t += delta
	if t >= period:
		t = 0
		label.visible_characters += 1
	
	if label.percent_visible >= 1.0:
		inactive_time += delta
		if inactive_time >= inactive_period + label.text.length()/100:
			if next():
				display_passage()
				inactive_time = 0
			else:
				emit_signal("intro_ended")

func next():
	importer.current_passage = importer.get_next_passage()
	return importer.current_passage
