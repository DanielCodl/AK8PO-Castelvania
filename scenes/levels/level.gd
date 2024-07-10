extends Node2D

const explosion_scene := preload("res://scenes/projectiles/explosion.tscn")
const bullet_scene := preload("res://scenes/projectiles/bullet.tscn")
@export var camera_limit: Vector4i
@onready var camera: Camera2D = get_tree().get_first_node_in_group('Player').get_cam()

func _ready():
	# camera 
	camera.limit_left = camera_limit.x
	camera.limit_top = camera_limit.y
	camera.limit_right = camera_limit.z
	camera.limit_bottom = camera_limit.w
	
	for i in $Main/Entities.get_child_count():
		var entity = $Main/Entities.get_child(i)
		if entity.has_signal('shoot'):
			entity.connect('shoot', create_bullet)
		
		if entity.has_signal('detonate'):
			entity.connect('detonate', create_explosion)

		var scene_name = get_tree().current_scene.name
		if scene_name in Global.enemy_data:
			entity.setup(Global.enemy_data[scene_name][i])

func create_bullet(pos, dir, bullet_type):
	var bullet = bullet_scene.instantiate()
	$Main/Projectiles.add_child(bullet)
	bullet.setup(pos, dir, bullet_type)
	if bullet_type == Global.guns.ROCKET:
		bullet.connect('detonate', create_explosion)


func create_explosion(pos):
	var explosion = explosion_scene.instantiate()
	$Main/Projectiles.add_child(explosion)
	explosion.position = pos
	

func _exit_tree():
	@warning_ignore("unassigned_variable")
	var current_enemy_data: Array
	for entity in $Main/Entities.get_children():
		current_enemy_data.append([entity.position, entity.velocity, entity.health])
	Global.enemy_data[get_tree().current_scene.name] = current_enemy_data
