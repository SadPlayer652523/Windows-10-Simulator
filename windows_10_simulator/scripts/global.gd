extends Node

var current_frame = 0xE052
var max_frame = 0xE0CB
var transition = 0xE06B
var transition_2 = 0xE09A

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass
	
func spin(spinner: Label, add_text="") -> void:
	var stage = 0
	while is_instance_valid(spinner):
		if add_text == "":
			spinner.text = char(current_frame)
		else:
			spinner.text = char(current_frame) + add_text
		current_frame += 1
		
		if stage == 0 and current_frame > transition_2:
			stage = 1
			current_frame = transition
		if current_frame > max_frame:
			current_frame = 0xE052
			stage = 0
		await get_tree().create_timer(0.025).timeout
