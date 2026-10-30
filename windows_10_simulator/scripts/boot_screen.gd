extends Control

@export var loading_scene: PackedScene
@export var login_scene: PackedScene

@onready var spinner: Label = $Spinner
@onready var shade: ColorRect = $Shade

var stage = 0

func _ready() -> void:
	var loading_screen = loading_scene.instantiate()
	loading_screen.next_scene = login_scene
	var boot_time = randf_range(5.0, 10.0)
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	Global.spin(spinner)
	await get_tree().create_timer(boot_time).timeout
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(shade, "color:a", 1.0, 0.3)
	await get_tree().create_timer(0.3).timeout
	get_tree().root.add_child(loading_screen)
	queue_free()
	
func _process(delta: float) -> void:
	pass
