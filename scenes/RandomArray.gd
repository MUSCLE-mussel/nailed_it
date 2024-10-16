extends Node2D
class_name RandomArray

class Point:
	var node: Node2D

@export var points: Array[RandomArrayPoint]

var time: float = 0

func get_random_position() -> Vector2:
	var random_position: Vector2 = position
	
	for point in points:
		var delta = point.position - position
		var t = sin((time + point.offset) * (2 * PI / point.phase))
		random_position += delta * t
	return random_position

func _process(delta: float) -> void:
	time += delta
