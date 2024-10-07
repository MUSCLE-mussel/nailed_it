class_name Nail
extends Node2D

@onready var perfect_hit_area: Area2D = $perfect_hit_area
@onready var average_hit_area: Area2D = $average_hit_area

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func _draw() -> void:
	pass
	#draw_circle(Vector2.ZERO, 100.0, Color.AQUA)
	
