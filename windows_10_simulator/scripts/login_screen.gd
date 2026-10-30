extends Control

@export var next_button_focused: StyleBoxFlat
@export var next_button_unfocused: StyleBoxFlat
@export var next_button_hover: StyleBoxFlat
@export var focused_password: StyleBoxFlat
@export var unfocused_password: StyleBoxFlat
@export var focused_password_hover: StyleBoxFlat
@export var unfocused_password_hover: StyleBoxFlat

@onready var wallpaper: TextureRect = $Wallpaper
@onready var blur_overlay: ColorRect = $"Blur Overlay"
@onready var first_screen: Control = $"Screen 1"
@onready var time_label: RichTextLabel = $"Screen 1/Time Label"
@onready var colon_label: RichTextLabel = $"Screen 1/Colon Label"
@onready var date_label: RichTextLabel = $"Screen 1/Date Label"
@onready var second_screen: Control = $"Screen 2"
@onready var sub_screen_1: Control = $"Screen 2/Sub-Screen 1"
@onready var password_box: LineEdit = $"Screen 2/Sub-Screen 1/Password Box"
@onready var next_button: Button = $"Screen 2/Sub-Screen 1/Next Button"
@onready var sub_screen_2: Control = $"Screen 2/Sub-Screen 2"
@onready var ok_button: Button = $"Screen 2/Sub-Screen 2/OK Button"
@onready var password_hint: RichTextLabel = $"Screen 2/Sub-Screen 1/Password Hint"
@onready var reset_password_button: Button = $"Screen 2/Sub-Screen 1/Reset Password Button"
@onready var ok_button_focus_border: Control = $"Screen 2/Sub-Screen 2/OK Button Focus Border"
@onready var sub_screen_3: Control = $"Screen 2/Sub-Screen 3"
@onready var welcome: Label = $"Screen 2/Sub-Screen 3/Welcome"

var tween_fade_time = 0.2
var blurred = false
var incorrect_password = false

func _ready() -> void:
	password_box.focus_mode = Control.FOCUS_NONE
	Input.warp_mouse(get_viewport().get_visible_rect().size / 2)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	password_box.release_focus()

func _process(delta: float) -> void:
	Global.get_system_date(date_label)
	Global.get_system_time(time_label, colon_label, true)
	
	if blurred:
		password_box.editable = true
	else:
		password_box.editable = false

func _input(event: InputEvent) -> void:
	if (event is InputEventKey or event is InputEventMouseButton) and event.pressed:
		if !blurred:
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
	second_screen.show()
	tween.tween_property(second_screen, "modulate:a", 1.0, tween_fade_time)
	password_box.focus_mode = Control.FOCUS_ALL
	password_box.grab_focus()

func unblur():
	var tween = get_tree().create_tween().set_parallel(true).set_trans(Tween.TRANS_LINEAR)
	var scale_tween = get_tree().create_tween().set_parallel(true).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	blurred = false
	scale_tween.tween_property(wallpaper, "scale", Vector2(1.0, 1.0), tween_fade_time)
	tween.tween_property(blur_overlay, "color:a", 0.21, tween_fade_time)
	tween.tween_property(first_screen, "modulate:a", 1.0, tween_fade_time)
	tween.tween_property(second_screen, "modulate:a", 0.0, tween_fade_time)
	second_screen.hide()
	password_box.focus_mode = Control.FOCUS_NONE
	password_box.release_focus()

func _on_password_box_focus_entered() -> void:
	next_button.add_theme_stylebox_override("normal", next_button_focused)
	password_box.add_theme_stylebox_override("normal", focused_password)

func _on_password_box_focus_exited() -> void:
	next_button.add_theme_stylebox_override("normal", next_button_unfocused)
	password_box.add_theme_stylebox_override("normal", unfocused_password)

func _on_password_box_mouse_entered() -> void:
	if next_button.has_focus() or password_box.has_focus():
		password_box.add_theme_stylebox_override("focus", focused_password_hover)
		next_button.add_theme_stylebox_override("normal", next_button_hover)
	else:
		password_box.add_theme_stylebox_override("normal", unfocused_password_hover)
		next_button.add_theme_stylebox_override("normal", next_button_hover)

func _on_password_box_mouse_exited() -> void:
	password_box.add_theme_stylebox_override("focus", focused_password)
	if next_button.has_focus() or password_box.has_focus():
		next_button.add_theme_stylebox_override("normal", next_button_focused)
		password_box.add_theme_stylebox_override("normal", focused_password)
	else:
		next_button.add_theme_stylebox_override("normal", next_button_unfocused)
		password_box.add_theme_stylebox_override("normal", unfocused_password)

func _on_password_box_text_submitted(new_text: String) -> void:
	_on_next_button_pressed()

func _on_next_button_pressed() -> void:
	password_box.add_theme_stylebox_override("normal", unfocused_password)
	password_box.grab_focus()
	var entered_password = password_box.text
	password_box.text = ""
	var hashed_entered_password = Global.hash_password(entered_password)
	if hashed_entered_password == Global.hashed_password:
		var welcome_time = randf_range(5.0, 10.0)
		sub_screen_1.hide()
		sub_screen_2.hide()
		sub_screen_3.show()
		Global.spin(welcome, " Welcome")
		await get_tree().create_timer(welcome_time).timeout
		get_tree().change_scene_to_file("res://scenes/desktop.tscn")
	else:
		sub_screen_1.hide()
		sub_screen_2.show()
		ok_button_focus_border.show()
		ok_button.grab_focus()

func _on_next_button_button_down() -> void:
	password_box.add_theme_stylebox_override("normal", focused_password_hover)

func _on_ok_button_pressed() -> void:
	password_box.add_theme_stylebox_override("normal", focused_password)
	next_button.add_theme_stylebox_override("normal", next_button_focused)
	password_box.grab_focus()
	incorrect_password = true
	password_hint.show()
	reset_password_button.show()
	sub_screen_1.show()
	sub_screen_2.hide()

func _on_ok_button_focus_exited() -> void:
	ok_button_focus_border.hide()
