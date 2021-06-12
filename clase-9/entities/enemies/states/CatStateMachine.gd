extends "res://entities/state_machine.gd"
class_name CatStateMachine

enum STATES {
	IDLE,
	SHOOT,
	PATROL,
	DEAD
}

func _ready():
	states_map = {
		STATES.IDLE: $Idle,
		STATES.SHOOT: $Shoot,
		STATES.PATROL: $Patrol,
		STATES.DEAD: $Dead
	}
	START_STATE = STATES.IDLE

func _physics_process(delta):
	current_state.update(delta)

func _change_state(state_name):
	"""
	The base state_machine interface this node extends does most of the work
	"""
	if not _active:
		return
	._change_state(state_name)


func notify_hit(amount):
	current_state.notify_hit(amount)
