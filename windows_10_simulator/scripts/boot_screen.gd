extends Control

@onready var spinner: Label = $Spinner
@onready var shade: ColorRect = $Shade

var stage = 0

func _ready() -> void:
	var boot_time = randf_range(5.0, 8.0)
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	Global.spin(spinner)
	await get_tree().create_timer(boot_time).timeout
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(shade, "color:a", 1.0, 0.3)
	await tween.finished
	get_tree().change_scene_to_file("res://scenes/login_screen.tscn")
	
func _process(delta: float) -> void:
	pass
