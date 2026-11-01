extends Node

const hashed_password = "ce37d910f279d36deb9a76f42aa7e40b"

var starting_frame = 0xE052
var current_frame = 0xE052
var max_frame = 0xE0CB
var transition = 0xE06B
var transition_2 = 0xE09A

var loading_text = "Welcome"
var spin_active = false

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass
	
func spin(spinner: Label, add_text="") -> void:
	spin_active = false
	await get_tree().process_frame
	spin_active = true
	var stage = 0
	current_frame = starting_frame
	while is_instance_valid(spinner) and spin_active:
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
		
func get_system_time_for_login(label: RichTextLabel, colon: RichTextLabel):
	var time_dict = Time.get_datetime_dict_from_system()
	var hours = "%02d" % time_dict.hour
	var minutes = "%02d" % time_dict.minute
	hours = int(hours) % 12
	if hours == 0:
		hours = 12
	
	if hours >= 10 and hours != 11 and hours != 1:
		label.text = str(hours) + "\t" + minutes
		colon.position.x = 104
	elif hours == 11:
		label.text = str(hours) + " " + minutes
		colon.position.x = 90
	elif hours == 1:
		label.text = str(hours) + " " + minutes
		colon.position.x = 58
	else:
		label.text = str(hours) + " " + minutes
		colon.position.x = 72
	
func get_system_date_for_login(label: RichTextLabel):
	var date_dict = Time.get_date_dict_from_system()
	var weekdays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
	var months = ["", "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
	
	var current_weekday = weekdays[date_dict.weekday]
	var current_month = months[date_dict.month]
	var current_day = date_dict.day
	
	if is_instance_valid(label):
		label.text = current_weekday + ", " + current_month + " " + str(current_day)
		
func get_system_time(label: RichTextLabel):
	var time_dict = Time.get_datetime_dict_from_system()
	var hours = "%02d" % time_dict.hour
	var minutes = "%02d" % time_dict.minute
	var time = ""
	if int(hours) > 11:
		time = "PM"
	else:
		time = "AM"
	hours = int(hours) % 12
	if hours == 0:
		hours = 12
		
	label.text = str(hours) + ":" + minutes + " " + time
	
func get_system_date(label: RichTextLabel):
	var date_dict = Time.get_date_dict_from_system()
	label.text = str(date_dict.month) + "/" + str(date_dict.day) + "/" + str(date_dict.year)
		
func hash_password(password: String) -> String:
	var hash = HashingContext.new()
	hash.start(HashingContext.HASH_MD5)
	hash.update(password.to_utf8_buffer())
	return hash.finish().hex_encode()
