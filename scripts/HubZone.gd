extends CollisionShape2D
class_name HubZone

var hovered: bool = false
var index: int = -1
var done: bool = false

signal clicked(this: HubZone)

func _process(_delta: float) -> void:
	hovered = false
	
	if done: return
	
	var rect = shape.get_rect()
	rect.position += position
	hovered = rect.has_point(get_global_mouse_position())
	
	if hovered && Input.is_action_just_pressed("click"):
		clicked.emit(self)
		
	queue_redraw()
	pass

func _draw() -> void:
	var rect = shape.get_rect()
	
	var color: Color = Color.DODGER_BLUE
	if done: color = Color.REBECCA_PURPLE
	elif hovered: color = Color.AQUA
	
	draw_rect(rect, color)
