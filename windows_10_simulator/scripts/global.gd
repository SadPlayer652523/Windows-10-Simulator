extends Node

var current_frame = 0xE052
var max_frame = 0xE0CB
var transition = 0xE06B
var transition_2 = 0xE09A

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass
	
func spin(spinner: Label, add_text="") -> void:
	var stage = 0
	while is_instance_valid(spinner):
		if add_text == "":
			spinner.text = char(current_frame)
		else:
			spinner.text = char(current_frame) + add_text
		current_frame += 1
		
		if stage == 0 and current_frame > transition_2:
			stage = 1
			current_frame = transition
		if current_frame > max_frame:
			current_frame = 0xE052
			stage = 0
		await get_tree().create_timer(0.025).timeout
		
func get_system_time(label: RichTextLabel, colon: RichTextLabel, login=false):
	var time_dict = Time.get_datetime_dict_from_system()
	var hours = "%02d" % time_dict.hour
	var minutes = "%02d" % time_dict.minute
	hours = int(hours) % 12
	if hours == 0:
		hours = 12
	
	if hours >= 10:
		label.text = hours + "\t" + minutes
		if login:
			colon.position = Vector2(148, 430)
	else:
		label.text = str(hours) + " " + minutes
		if login:
			colon.position = Vector2(106, 430)
	
func get_system_date(label: RichTextLabel):
	var date_dict = Time.get_date_dict_from_system()
	var weekdays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
	var months = ["", "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
	
	var current_weekday = weekdays[date_dict.weekday]
	var current_month = months[date_dict.month]
	var current_day = date_dict.day
	
	label.text = current_weekday + ", " + current_month + " " + str(current_day)
