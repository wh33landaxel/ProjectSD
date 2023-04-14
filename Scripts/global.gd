extends Node

signal alert_changed(alert_mode)

var player
enum ALERT_MODES { ALERT_OFF, ALERT_ON }
var alert_mode: ALERT_MODES = ALERT_MODES.ALERT_OFF:
	set(value):
		alert_mode = value
		emit_signal("alert_changed", value)
var alert_time = 5.0
var cur_time = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print("Alert Mode: ", alert_mode)
	if alert_mode == ALERT_MODES.ALERT_ON:
		cur_time += delta
		if cur_time >= alert_time:
			cur_time = 0 
			alert_mode = ALERT_MODES.ALERT_OFF

	
