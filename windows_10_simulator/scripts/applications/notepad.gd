extends Control

@onready var close_button_label: Label = $"Window/Title Bar/Close Button/Close Button Label"
@onready var title: RichTextLabel = $"Window/Title Bar/Title"
@onready var text_edit: TextEdit = $Window/TextEdit

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass

func _on_close_button_mouse_entered() -> void:
	close_button_label.add_theme_color_override("font_color", Color.html("#ffffff"))

func _on_close_button_mouse_exited() -> void:
	close_button_label.add_theme_color_override("font_color", Color.html("#000000"))

func _on_text_edit_text_changed() -> void:
	if !text_edit.text.length() > 0:
		title.text = "Untitled - Notepad"
	else:
		title.text = "*Untitled - Notepad"
