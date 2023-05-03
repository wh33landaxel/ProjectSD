extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var tween = get_tree().create_tween()
	
	#Sets transition and ease for all following tweens
	tween.set_trans(Tween.TRANS_QUART) 
	tween.set_ease(Tween.EASE_OUT)
	
	tween.tween_property(self,"modulate:a",0.0,0.5)
	
	tween.tween_callback(queue_free)
