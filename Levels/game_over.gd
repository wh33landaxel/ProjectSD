extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	ScoreDisplay.panel.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("reset_game"):
		ScoreDisplay.panel.visible = true
		ScoreDisplay.restart_game()
		LevelManager.restart_game()
