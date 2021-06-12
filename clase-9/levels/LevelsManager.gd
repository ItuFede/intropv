extends Node

onready var loading = $Loading
onready var levels_container = $LevelsContainer
onready var menu = $Menu

export (Array, String) var levels

var current_level:int = 0
var resetting:bool = true

func _ready():
	loading.start_animation()
	current_level = 0
	yield(get_tree().create_timer(5.0),"timeout")
	call_deferred("initialize")

func initialize():
	if levels_container.get_child_count() > 0:
		var existing_level = levels_container.get_child(0)
		levels_container.remove_child(existing_level)
		existing_level.queue_free()
	var level = load(levels[current_level]).instance()
	levels_container.add_child(level)
	level.connect("restart_requested", self, "reset_level")
	level.connect("level_won", self, "_on_level_won")
	loading.stop_animation()
	menu.can_pause = true
	
	yield(get_tree().create_timer(2.0), "timeout")
	
	resetting = false

func reset_level():
	if !resetting:
		resetting = true
		initialize()

func _on_level_won():
	current_level += 1
	resetting = true
	if current_level > levels.size()-1:
		exit_game()
	else:
		loading.start_animation()
		initialize()

func exit_game():
	get_tree().quit()
