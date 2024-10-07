extends Node2D

@onready var hammer: Hammer = $hammer
@onready var debug: Label = $debug

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var hammer_debug = ""
	#hammer_debug += "time: %.2f, %.2f, %.2f\n" % [hammer.time, hammer.phase1_time, hammer.phase2_time]
	#hammer_debug += "amp: %.2f\n" % [hammer.amplitude_ratio]
	#hammer_debug += "pha1: %.2f\n" % [hammer.phase1_ratio]
	#hammer_debug += "pha2: %.2f\n" % [hammer.phase2_ratio]
	hammer_debug += "last_hit: %s\n" % [hammer.last_hit]
	
	debug.text = hammer_debug
	pass
