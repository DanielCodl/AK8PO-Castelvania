extends Entity

@onready var player = get_tree().get_first_node_in_group('Player')
@onready var player_cam = player.get_cam()
@onready var cam_size = player_cam.get_viewport_rect().size.x / player_cam.zoom.x
@export var limits: Vector2i

var y_range := Vector2(-50,50)
var y_offset: float

var rng = RandomNumberGenerator.new()

signal detonate(pos)

func _ready():
	health = Global.enemy_parameters['monster']['health']


func _process(_delta):
	var x =  player.position.x + cam_size / 2 - 10
	x = max(limits.x, min(limits.y, x)) 
	var y = player.position.y + y_offset
	position = Vector2(x,y)


func _on_attack_timer_timeout():
	$AnimationPlayer.current_animation = 'attack'
	$Timers/AttackTimer.wait_time = rng.randf_range(0.5, 2.0)
	$Timers/AttackTimer.start()


func _on_move_timer_timeout():
	var tween = create_tween()
	tween.tween_property(self, 'y_offset', rng.randf_range(y_range.x, y_range.y), 0.6)
	tween.tween_callback($Timers/MoveTimer.start)


func trigger_attack():
	var option_index = rng.randi_range(0, $BulletOptions.get_child_count() - 1)
	var selected = $BulletOptions.get_child(option_index)
	for marker in selected.get_children():
		shoot.emit(marker.global_position, Vector2.LEFT, Global.guns.AK)


func trigger_death():
	$Timers/MoveTimer.stop()
	$Timers/AttackTimer.stop()
	$AnimationPlayer.current_animation = 'death'


func return_to_idle():
	$AnimationPlayer.current_animation = 'idle'


func get_sprites():
	return [$Sprite2D]

func explode():
	@warning_ignore("narrowing_conversion")
	var rand_x = rng.randi_range(global_position.x - 20, global_position.x + 20)
	@warning_ignore("narrowing_conversion")
	var rand_y = rng.randi_range(global_position.y - 20, global_position.y + 20)
	detonate.emit(Vector2(rand_x, rand_y))
