class_name Hammer
extends Node2D

var time: float = 0

@export var target_nail: Nail

@export var amplitude_min: float
@export var amplitude_max: float
@export var amplitude_noise_speed: float = 1
var amplitude_noise: FastNoiseLite
var amplitude_ratio: float

@export var phase1_min: float
@export var phase1_max: float
@export var phase1_noise_speed: float = 1
var phase1_time: float = 0
var phase1_noise: FastNoiseLite
var phase1_ratio: float

@export var phase2_min: float
@export var phase2_max: float
@export var phase2_noise_speed: float = 1
var phase2_time: float = 0
var phase2_noise: FastNoiseLite
var phase2_ratio: float

@export var angle_speed: float = 0.1
@export var angle_noise_speed: float = 1
var angle_noise: FastNoiseLite
var angle: float

@onready var collision: Area2D = $collision
@onready var animation_player: AnimationPlayer = $animation_player

var hold_time: float = 0
@export var valid_hold_time: float = 0.5

var last_hit = ""

func _init() -> void:
	amplitude_noise = FastNoiseLite.new()
	amplitude_noise.noise_type = FastNoiseLite.TYPE_PERLIN
	amplitude_noise.seed = 1
	
	phase1_noise = FastNoiseLite.new()
	phase1_noise.noise_type = FastNoiseLite.TYPE_PERLIN
	phase1_noise.seed = 2
	
	phase2_noise = FastNoiseLite.new()
	phase2_noise.noise_type = FastNoiseLite.TYPE_PERLIN
	phase2_noise.seed = 3
	
	angle_noise = FastNoiseLite.new()
	angle_noise.noise_type = FastNoiseLite.TYPE_PERLIN
	angle_noise.seed = 4

func _process(delta: float) -> void:
	time += delta
	
	# amplitude
	amplitude_ratio = (amplitude_noise.get_noise_1d(time * amplitude_noise_speed) + 1) / 2
	var amplitude = amplitude_min + (amplitude_max - amplitude_min) * amplitude_ratio
	
	# phase
	phase1_ratio = (phase1_noise.get_noise_1d(time * phase1_noise_speed) + 1) / 2
	var phase1 = phase1_min + (phase1_max - phase1_min) * phase1_ratio
	phase1_time += delta * 2 * PI / phase1
	
	phase2_ratio = (phase2_noise.get_noise_1d(time * phase2_noise_speed) + 1) / 2
	var phase2 = phase2_min + (phase2_max - phase2_min) * phase2_ratio
	phase2_time += delta * 2 * PI / phase2

	# angle
	angle = time * angle_speed + angle_noise.get_noise_1d(time * angle_noise_speed) * PI
	var direction = Vector2(1, 0).rotated(angle)
	
	# assemble & compute position
	position = target_nail.global_position
	var sine = (sin(phase1_time) + sin(phase2_time)) / 2
	position += direction * (sine * amplitude)
	
	var strike_down = Input.is_action_pressed("strike")
	var valid_strike = false
	if strike_down:
		if hold_time == 0:
			animation_player.play("hammer_up")
		hold_time += delta
	else:
		if hold_time > 0:
			if hold_time > valid_hold_time:
				animation_player.play("hammer_down")
				valid_strike = true
			else:
				animation_player.stop()
			hold_time = 0
			
	if valid_strike:
		if collision.overlaps_area(target_nail.perfect_hit_area):
			last_hit = "perfect"
		elif collision.overlaps_area(target_nail.average_hit_area):
			last_hit = "average"
		else:
			last_hit = "missed"
	#collision.overlaps_area()
