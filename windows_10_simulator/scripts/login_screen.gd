extends Control

@onready var blur_overlay: ColorRect = $"Blur Overlay"
@onready var time_label: RichTextLabel = $"Time Label"
@onready var colon_label: RichTextLabel = $"Colon Label"
@onready var date_label: RichTextLabel = $"Date Label"

var current_blur = 0.0
var target_blur = 2.0
var fade_speed = 4.0
var tween_fade_time = 0.16
var blurred = false

func _ready() -> void:
	Input.warp_mouse(get_viewport().get_visible_rect().size / 2)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _process(delta: float) -> void:
	Global.get_system_date(date_label)
	Global.get_system_time(time_label, colon_label, true)

	if abs(current_blur - target_blur) < 0.01:
		current_blur = target_blur
		
	if current_blur != target_blur and blurred:
		current_blur = lerp(current_blur, target_blur, fade_speed * delta)
	elif !blurred:
		current_blur = lerp(current_blur, 0.0, fade_speed * delta)
		
	blur_overlay.set_instance_shader_parameter("blur_amount", current_blur)
	
func _input(event: InputEvent) -> void:
	if (event is InputEventKey or event is InputEventMouseButton) and event.pressed:
		blur()
		await get_tree().create_timer(60.0).timeout
		unblur()
		
func blur():
	var tween = get_tree().create_tween().set_parallel(true).set_trans(Tween.TRANS_LINEAR)
	blurred = true
	tween.tween_property(time_label, "modulate:a", 0.0, tween_fade_time)
	tween.tween_property(colon_label, "modulate:a", 0.0, tween_fade_time)
	tween.tween_property(date_label, "modulate:a", 0.0, tween_fade_time)
	
func unblur():
	var tween = get_tree().create_tween().set_parallel(true).set_trans(Tween.TRANS_LINEAR)
	blurred = false
	tween.tween_property(time_label, "modulate:a", 1.0, tween_fade_time)
	tween.tween_property(colon_label, "modulate:a", 1.0, tween_fade_time)
	tween.tween_property(date_label, "modulate:a", 1.0, tween_fade_time)
