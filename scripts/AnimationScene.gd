class_name AnimationScene
extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var animation_name: StringName

var is_animation_finished: bool

func _ready() -> void:
	animation_player.animation_finished.connect(on_animation_finished)

func play() -> void:
	is_animation_finished = false
	animation_player.play(animation_name)
	
func on_animation_finished(_anim_name: StringName):
	is_animation_finished = true
