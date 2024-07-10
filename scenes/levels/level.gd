extends Node2D

const explosion_scene := preload("res://scenes/projectiles/explosion.tscn")

func _ready():
	for entity in $Main/Entities.get_children():
		if entity.has_signal('shoot'):
			entity.connect('shoot', create_bullet)
		
		if entity.has_signal('detonate'):
			entity.connect('detonate', create_explosion)

func create_bullet(pos, dir, bullet_type):
	print(pos)
	print(dir)
	print(bullet_type)


func create_explosion(pos):
	var explosion = explosion_scene.instantiate()
	$Main/Projectiles.add_child(explosion)
	explosion.position = pos
	
