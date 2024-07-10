extends Node2D

const explosion_scene := preload("res://scenes/projectiles/explosion.tscn")
const bullet_scene := preload("res://scenes/projectiles/bullet.tscn")

func _ready():
	for entity in $Main/Entities.get_children():
		if entity.has_signal('shoot'):
			entity.connect('shoot', create_bullet)
		
		if entity.has_signal('detonate'):
			entity.connect('detonate', create_explosion)


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
	
