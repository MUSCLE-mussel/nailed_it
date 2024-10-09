extends Node2D
class_name GameScene

@onready var nail: Nail = $nail
@onready var hammer: Hammer = $hammer
@onready var placeholder_ui: Label = $placeholder_ui

const wanted_hits: int = 3
var remaining_hits: int = 0

var game_over: bool = false

func init() -> void:
	game_over = false
	remaining_hits = wanted_hits

func on_hammer_hit(hitType: Hammer.HitType):
	if hitType != Hammer.HitType.MISSED:
		remaining_hits -= 1
		
	if remaining_hits == 0:
		game_over = true

func _ready() -> void:
	hammer.hammer_hit.connect(on_hammer_hit)
	pass

func _process(_delta: float) -> void:
	placeholder_ui.text = "Remaining Hits: %d" % [remaining_hits]
