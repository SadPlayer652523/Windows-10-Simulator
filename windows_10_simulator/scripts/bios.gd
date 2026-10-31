extends Control

@export var boot_scene: PackedScene

@onready var shade: ColorRect = $Shade
@onready var bios_label: Label = $"BIOS Label"

func _ready() -> void:
	var boot_screen = boot_scene.instantiate()
	var idle_time = randf_range(3.0, 7.0)
	await get_tree().create_timer(idle_time).timeout
	show_bios_text()
	shade.hide()
	var boot_time = randf_range(4.0, 9.0)
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	await get_tree().create_timer(boot_time).timeout
	get_tree().root.add_child(boot_screen)
	queue_free()

func _process(delta: float) -> void:
	pass

func show_bios_text():
	await get_tree().create_timer(2.0).timeout
	bios_label.show()
