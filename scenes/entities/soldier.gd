extends Entity

var x_direction := 1
var speed = Global.enemy_parameters['soldier']['speed']
var speed_modifier := 1
var attack := false
@onready var player = get_tree().get_first_node_in_group('Player')

func _ready():
	health = Global.enemy_parameters['soldier']['health']

func _process(_delta):
	if health > 0 :
		velocity.x = x_direction * speed * speed_modifier
		check_cliff()
		check_player_distance()
		animate()
		move_and_slide()


func check_player_distance():
	if position.distance_to(player.position) < 120:
		attack = true
		speed_modifier = 0
	else:
		attack = false
		speed_modifier = 1


func animate():
	$Sprite2D.flip_h = x_direction < 0
	if attack:
		var side = 'right'
		var difference = (player.position - position).normalized()
		$Sprite2D.flip_h = difference.x < 0
		if difference.y < -0.5 and abs(difference.x) < 0.4:
			side = 'up'
		if difference.y > 0.5 and abs(difference.x) < 0.4:
			side = 'down'
		
		$AnimationPlayer.current_animation = 'shoot_'+ side
		return
	$AnimationPlayer.current_animation = 'run' if x_direction else 'idle'


func _on_wall_check_area_body_entered(_body):
	x_direction *= -1


func check_cliff():
	if x_direction > 0 and not $FloorRays/Right.get_collider():
		x_direction = -1
	if x_direction < 0 and not $FloorRays/Left.get_collider():
		x_direction = 1


func trigger_attack():
	var dir = (player.position - position).normalized()
	shoot.emit(position + dir * 20, dir, Global.guns.AK)


func get_sprites():
	return [$Sprite2D]

func trigger_death():
	speed_modifier = 0
	$AnimationPlayer.current_animation = 'death'
	call_deferred("disable_collisions")
	
func disable_collisions():
	$CollisionShape2D.disabled = true

func setup(data):
	super.setup(data)
	speed_modifier = 0
	$AnimationPlayer.stop()
	$Sprite2D.frame = 22
