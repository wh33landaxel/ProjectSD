extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.alert_changed.connect(on_alert_change)


func on_alert_change(alert_change):
	#Need code for what happens with alerts
	#Possibly need a music manager singleton
	if alert_change == Global.ALERT_MODES.ALERT_ON:
		$AlertMusicPlayer.play()
		if $Alert != null:
			$Alert.visible = true
	else:
		$AlertMusicPlayer.stop()
