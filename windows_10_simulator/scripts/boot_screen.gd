extends Control

@onready var spinner: Label = $Spinner

var current_frame = 0xE052
var max_frame = 0xE0CB

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	spin()
	
func _process(delta: float) -> void:
	pass

func spin() -> void:
	while true:
		spinner.text = char(current_frame)
		current_frame += 1
	
		if current_frame > max_frame:
			current_frame = 0xE052
		await get_tree().create_timer(0.016).timeout
