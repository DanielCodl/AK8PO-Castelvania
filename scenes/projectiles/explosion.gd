extends AnimatedSprite2D

func _ready():
	$AudioStreamPlayer2D.play()

func _on_animation_finished():
	queue_free()
