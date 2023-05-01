extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body.is_in_group("player"):
		TextDisplay.display_text("OUCH!", 2)
		await get_tree().create_timer(1.0).timeout
		TextDisplay.hide_display()
		LevelManager.restart_level()
		
		
		

