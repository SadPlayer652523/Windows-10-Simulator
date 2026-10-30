extends Control

@export var next_scene: PackedScene

@onready var spinner: Label = $Spinner
@onready var text: RichTextLabel = $Text

func _ready() -> void:
	Global.spin(spinner)
	var next_screen = next_scene.instantiate()
	text.text = Global.loading_text
	var loading_time = randf_range(5.0, 10.0)
	await get_tree().create_timer(loading_time).timeout
	get_tree().root.add_child(next_screen)
	queue_free()

func _process(delta: float) -> void:
	pass
