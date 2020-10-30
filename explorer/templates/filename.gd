extends Label

export var shifting_letters = false
var period = 0.05
var t = 0

export var progressive = true
export (Array, String) var progressive_sequence
var progressive_period = 3
var progressive_t = 0
var progressive_i = 0

var original_text

func _ready():
	original_text = text
	if progressive:
		text = progressive_sequence[0]
		visible_characters = 0

func _process(delta):
	if shifting_letters:
		t += delta
		
		if t > period:
			t = 0
		
			var char_array = text.to_utf8()
			for i in char_array.size():
				char_array[i] = randi()%95 + 32
			
			var bla = PoolByteArray(char_array)
			text = bla.get_string_from_utf8()
	elif progressive and not progressive_sequence.empty():
		progressive_t += delta
		
		if progressive_t / period > visible_characters:
			visible_characters += 1
		
		if progressive_t > progressive_period:
			progressive_t = 0
			progressive_i += 1
			if progressive_i < progressive_sequence.size():
				visible_characters = 0
				text = progressive_sequence[progressive_i]
