extends Node2D

var cloud = preload("res://Scenes/cloud.tscn")
var enemy = preload("res://Scenes/eye_bot.tscn")
var score = 0

@onready var game_over_hud = $GameOverHUD
@onready var score_label = $HUD/ScoreLabel
@onready var spawn_point = $SpawnPoint
@onready var player = $Player

func _ready():
	score = 0
	game_over_hud.hide()
	Global.alert_changed.connect(on_alert_change)

func _physics_process(delta):
	if Input.is_action_just_pressed("reset_game"):
		_reset_scene()

func game_over(): 
	game_over_hud.show()
	
func new_game():
	game_over_hud.hide() 
	player.start(spawn_point.position)

func _on_player_player_ded():
	game_over()

func _on_button_pressed():
	new_game()

func _on_camera_alert():
	#TODO: Figure out what we want to do with a camera alert
	pass
	
func _reset_scene():
	get_tree().reload_current_scene()

func on_alert_change(alert_change):
	#Need code for what happens with alerts
	#Possibly need a music manager singleton
	if alert_change == Global.ALERT_MODES.ALERT_ON:
		$NiceMusicPlayer.stop()
		$AlertMusicPlayer.play()
	else:
		$NiceMusicPlayer.play()
		$AlertMusicPlayer.stop()
