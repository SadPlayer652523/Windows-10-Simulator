extends Control

@onready var start_logo: TextureRect = $"Taskbar/Start Button/Logo"
@onready var time_label: RichTextLabel = $"Taskbar/Date & Time Button/Time Label"
@onready var date_label: RichTextLabel = $"Taskbar/Date & Time Button/Date Label"
@onready var search_icon: Label = $"Taskbar/Search Bar/Search Icon"
@onready var search_placeholder: Label = $"Taskbar/Search Bar/Search Placeholder"
@onready var search_bar: LineEdit = $"Taskbar/Search Bar"

func _ready() -> void:
	Global.get_system_time(time_label)
	Global.get_system_date(date_label)
	Input.warp_mouse(get_viewport().get_visible_rect().size / 2)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _process(delta: float) -> void:
	Global.get_system_time(time_label)
	Global.get_system_date(date_label)

func _on_start_button_mouse_entered() -> void:
	start_logo.modulate = Color.html("#0078d7")

func _on_start_button_mouse_exited() -> void:
	start_logo.modulate = Color.html("#ffffff")

func _on_search_bar_focus_entered() -> void:
	search_icon.add_theme_color_override("font_color", Color.html("#000000"))
	search_placeholder.add_theme_color_override("font_color", Color.html("#000000"))

func _on_search_bar_focus_exited() -> void:
	search_icon.add_theme_color_override("font_color", Color.html("#ffffffbe"))
	search_placeholder.add_theme_color_override("font_color", Color.html("#ffffffbe"))
	search_bar.text = ""
	search_placeholder.show()

func _on_search_bar_text_changed(new_text: String) -> void:
	if new_text.length() > 0:
		search_placeholder.hide()
	else:
		search_placeholder.show()
