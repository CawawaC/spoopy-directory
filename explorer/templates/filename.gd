extends Label

var shifting_letters = false
var original_text
var period = 0.05
var Delta = 0

func _ready():
	original_text = text

func _process(delta):
	if shifting_letters:
		Delta += delta
		
		if Delta > period:
			Delta = 0
		
			var char_array = text.to_utf8()
			for i in char_array.size():
				char_array[i] = randi()%95 + 32
			
			var bla = PoolByteArray(char_array)
			text = bla.get_string_from_utf8()
