extends CharacterBody2D

var active := false 
var speed := Global.enemy_parameters['drone']['speed']
@onready var player = get_tree().get_first_node_in_group('Player')
signal detonate(pos: Vector2)

func _process(_delta):
	if active:
		var direction = (player.position - position).normalized()
		velocity = direction * speed 
		move_and_slide()

func _on_player_detection_area_body_entered(_body):
	active = true


func _on_collsion_detection_area_body_entered(body):
	if body != self:
		detonate.emit(global_position)
		queue_free()
