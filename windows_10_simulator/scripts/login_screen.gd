extends Control

@onready var wallpaper: TextureRect = $Wallpaper
@onready var blur_overlay: ColorRect = $"Blur Overlay"
@onready var time_label: RichTextLabel = $"First Screen/Time Label"
@onready var colon_label: RichTextLabel = $"First Screen/Colon Label"
@onready var date_label: RichTextLabel = $"First Screen/Date Label"
@onready var first_screen: Control = $"First Screen"
@onready var second_screen: Control = $"Second Screen"

var tween_fade_time = 0.2
var blurred = false

func _ready() -> void:
	Input.warp_mouse(get_viewport().get_visible_rect().size / 2)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _process(delta: float) -> void:
	Global.get_system_date(date_label)
	Global.get_system_time(time_label, colon_label, true)
	
func _input(event: InputEvent) -> void:
	if (event is InputEventKey or event is InputEventMouseButton) and event.pressed:
		blur()
		await get_tree().create_timer(60.0).timeout
		unblur()
		
func blur():
	var tween = get_tree().create_tween().set_parallel(true).set_trans(Tween.TRANS_LINEAR)
	var scale_tween = get_tree().create_tween().set_parallel(true).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	blurred = true
	scale_tween.tween_property(wallpaper, "scale", Vector2(1.02, 1.02), tween_fade_time)
	tween.tween_property(blur_overlay, "color:a", 0.42, tween_fade_time)
	tween.tween_property(first_screen, "modulate:a", 0.0, tween_fade_time)
	tween.tween_property(second_screen, "modulate:a", 1.0, tween_fade_time)
	
func unblur():
	var tween = get_tree().create_tween().set_parallel(true).set_trans(Tween.TRANS_LINEAR)
	var scale_tween = get_tree().create_tween().set_parallel(true).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	blurred = false
	scale_tween.tween_property(wallpaper, "scale", Vector2(1.0, 1.0), tween_fade_time)
	tween.tween_property(blur_overlay, "color:a", 0.21, tween_fade_time)
	tween.tween_property(first_screen, "modulate:a", 1.0, tween_fade_time)
	tween.tween_property(second_screen, "modulate:a", 0.0, tween_fade_time)
