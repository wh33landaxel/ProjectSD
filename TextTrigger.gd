extends Area2D

@export var text_to_show = ""
enum MOODS { HAPPY, SAD, FREAKED_OUT }
@export var mood_to_show: MOODS = MOODS.HAPPY
@export var one_time = true
var shown = false

#Door Texts
const DOOR_CLOSED_TEXT = "Sorry bud, can't let you through until you disable the exclamation alarms"

func _ready():
	connect("body_entered", show_text)
	connect("body_exited", hide_text)
	

func show_text(coll):
	print("show the fuckin text")
	if get_parent().is_in_group("door"):
		#Yes this is horrible but game jam
		if get_parent().door_locked:
			text_to_show = DOOR_CLOSED_TEXT
			TextDisplay.display_text(text_to_show, mood_to_show)
			return
	elif coll.is_in_group("player") and !get_parent().is_in_group("door"):
		if one_time and shown:
			return
		shown = true
		TextDisplay.display_text(text_to_show, mood_to_show)

func hide_text(coll):
	if coll.is_in_group("player"):
		TextDisplay.hide_display()
	
