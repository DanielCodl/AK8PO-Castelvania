extends Area2D

var path: Path2D
var path_follow: PathFollow2D
@export var speed := 100
@export var offset := 0
@export var forward := true

func _ready():
	path = get_children()[-1]
	path_follow = PathFollow2D.new()
	path.add_child(path_follow)
	path_follow.progress = offset


func _process(delta):
	var direction = 1 if forward else -1
	path_follow.progress += speed * delta * direction
	position = path_follow.position


func _on_body_entered(_body):
	print('player hit')
