class_name Entity
extends CharacterBody2D

signal shoot(pos, dir, bullet_type)
var health := 100:
	set(value):
		health = value
		if health <= 0:
			trigger_death()

func hit(damage, nodes):
	if not $Timers/InvulTimer.time_left:
		health -= damage
		$Timers/InvulTimer.start()
		flash(nodes)


func flash(nodes):
	var tween = create_tween()
	tween.tween_method(set_flash_value.bind(nodes), 0.0, 1.0, 0.1).set_trans(Tween.TRANS_QUAD)
	tween.tween_method(set_flash_value.bind(nodes), 1.0, 0.0, 0.4).set_trans(Tween.TRANS_QUAD)

func set_flash_value(value: float, nodes):
	for node in nodes:
		node.material.set_shader_parameter('Progress', value)

func trigger_death():
	pass
