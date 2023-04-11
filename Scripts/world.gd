extends Node2D

var cloud = preload("res://Scenes/cloud.tscn")
var score = 0

func _ready():
	score = 0
	#instantiate_cloud(randi() % 2 == 0)
	$GameOverHUD.hide()

func game_over(): 
	get_tree().call_group("cloud", "queue_free")
	get_tree().call_group("rain_drop","queue_free")
	$GameOverHUD.show()
	
	
func new_game():
	$ScoreTimer.start()
	$GameOverHUD.hide() 
	get_tree().call_group("cloud", "queue_free")
	get_tree().call_group("rain_drop","queue_free") 
	$Player.start($SpawnPoint.position)
	score = 0
	$HUD/ScoreLabel.text = "Score: " + str(score)
	

func _on_cloud_timer_timeout():
	var moving_right = false
	if randi() % 2: 
		moving_right = true
	else: 
		moving_right = false
	
	#instantiate_cloud(moving_right)

func instantiate_cloud(moving_right):
	var c = cloud.instantiate()
	
	if moving_right:
		c.position = $CloudSpawnWest.position
		c.moving = true
		c.moving_right = true
		add_child(c)
	else:
		c.position = $CloudSpawnEast.position
		c.moving = true
		c.moving_right = false
		add_child(c)
	
	
func _on_score_timer_timeout():
	score += 1
	$HUD/ScoreLabel.text = "Score: " + str(score)


func _on_player_player_ded():
	$ScoreTimer.stop()
	game_over()

func _on_button_pressed():
	new_game()

