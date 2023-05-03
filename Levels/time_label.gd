extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	self.text = "Your time was: " + ScoreDisplay.time_elapsed
