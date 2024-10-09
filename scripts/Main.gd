extends Node2D

@onready var debug: Label = $debug

@onready var title_scene: Node2D = $title_scene
@onready var intro1_scene: AnimationScene = $intro1_scene
@onready var intro2_scene: AnimationScene = $intro2_scene
@onready var game_scene: GameScene = $game_scene
@onready var hub_scene: HubScene = $hub_scene
@onready var outro_scene: AnimationScene = $outro_scene
@onready var end_scene: Node2D = $end_scene

enum GameState { NONE, TITLE, INTRO1, TUTORIAL, INTRO2, HUB, GAME, OUTRO, END }
var state: GameState = GameState.NONE
var any_input_pressed: bool = false
var current_zone: int = -1

func _ready() -> void:
	set_scene_enabled(title_scene, false)
	set_scene_enabled(intro1_scene, false)
	set_scene_enabled(intro2_scene, false)
	set_scene_enabled(game_scene, false)
	set_scene_enabled(hub_scene, false)
	set_scene_enabled(outro_scene, false)
	set_scene_enabled(end_scene, false)
	
	set_state(GameState.TITLE)
	
func _input(event: InputEvent) -> void:
	if event.is_pressed():
		any_input_pressed = true

func _process(_delta: float) -> void:
	# update state
	match state:
		GameState.TITLE:
			if any_input_pressed:
				set_state(GameState.INTRO1)
				
		GameState.INTRO1:
			if intro1_scene.is_animation_finished:
				set_state(GameState.TUTORIAL)
				
		GameState.TUTORIAL:
			if game_scene.game_over:
				set_state(GameState.INTRO2)
				
		GameState.INTRO2:
			if intro2_scene.is_animation_finished:
				set_state(GameState.HUB)
				
		GameState.HUB:
			if hub_scene.selected_zone >= 0:
				current_zone = hub_scene.selected_zone
				set_state(GameState.GAME)
				
		GameState.GAME:
			if game_scene.game_over:
				assert(current_zone >= 0)
				hub_scene.zones[current_zone].done = true
				current_zone = -1
				
				var all_scenes_done: bool = true
				for zone in hub_scene.zones:
					if !zone.done:
						all_scenes_done = false
						break
				
				if all_scenes_done:
					set_state(GameState.OUTRO)
				else:
					set_state(GameState.HUB)
		
		GameState.OUTRO:
			if outro_scene.is_animation_finished:
				set_state(GameState.END)
				
		GameState.END:
			if any_input_pressed:
				reset_game()
				set_state(GameState.TITLE)
	
	# reset vars
	any_input_pressed = false
	
	# DEBUG
	var hammer_debug = ""
	#hammer_debug += "time: %.2f, %.2f, %.2f\n" % [hammer.time, hammer.phase1_time, hammer.phase2_time]
	#hammer_debug += "amp: %.2f\n" % [hammer.amplitude_ratio]
	#hammer_debug += "pha1: %.2f\n" % [hammer.phase1_ratio]
	#hammer_debug += "pha2: %.2f\n" % [hammer.phase2_ratio]
	hammer_debug += "game_state: %s\n" % [state]
	debug.text = hammer_debug
	
	pass

func reset_game():
	for zone in hub_scene.zones:
		zone.done = false

func set_state(new_state: GameState):
	if state == new_state: return
	
	# exit
	match state:
		GameState.TITLE:
			set_scene_enabled(title_scene, false)
			
		GameState.INTRO1:
			set_scene_enabled(intro1_scene, false)
			
		GameState.INTRO2:
			set_scene_enabled(intro2_scene, false)
			
		GameState.TUTORIAL:
			set_scene_enabled(game_scene, false)
			
		GameState.GAME:
			set_scene_enabled(game_scene, false)
			
		GameState.HUB:
			set_scene_enabled(hub_scene, false)
			
		GameState.OUTRO:
			set_scene_enabled(outro_scene, false)
			
		GameState.END:
			set_scene_enabled(end_scene, false)
		
	state = new_state
	
	# enter
	match state:
		GameState.TITLE:
			set_scene_enabled(title_scene, true)
			
		GameState.INTRO1:
			set_scene_enabled(intro1_scene, true)
			intro1_scene.play()
			
		GameState.INTRO2:
			set_scene_enabled(intro2_scene, true)
			intro2_scene.play()
			
		GameState.TUTORIAL:
			set_scene_enabled(game_scene, true)
			game_scene.init()
			
		GameState.GAME:
			set_scene_enabled(game_scene, true)
			game_scene.init()
			
		GameState.HUB:
			set_scene_enabled(hub_scene, true)
			hub_scene.init()
			
		GameState.OUTRO:
			set_scene_enabled(outro_scene, true)
			outro_scene.play()
			
		GameState.END:
			set_scene_enabled(end_scene, true)
	

func set_scene_enabled(node: Node2D, enabled: bool):
	if enabled:
		node.visible = true
		node.process_mode = Node.PROCESS_MODE_INHERIT
	else:
		node.visible = false
		node.process_mode = Node.PROCESS_MODE_DISABLED
