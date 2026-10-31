extends Control

@export var next_scene: PackedScene

@onready var spinner: Label = $Spinner
@onready var text: RichTextLabel = $Text

func _ready() -> void:
	Global.spin(spinner)
	text.text = Global.loading_text
	var loading_time = randf_range(5.0, 10.0)
	await get_tree().create_timer(loading_time).timeout
	if Global.loading_text != "Shutting down" and Global.loading_text != "Restarting":
		var next_screen = next_scene.instantiate()
		get_tree().root.add_child(next_screen)
		queue_free()
	else:
		if Global.loading_text == "Restarting":
			get_tree().change_scene_to_file("res://scenes/bios.tscn")
		else:
			get_tree().quit()

func _process(delta: float) -> void:
	pass
