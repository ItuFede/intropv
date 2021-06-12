extends CanvasLayer

signal win_animation_finished()

const hearth_scene = preload("res://GUI/HearthTexture.tscn")

export (String) var win_text = "You win!"

onready var fade_tween = $Fade/Tween
onready var fade = $Fade/ScreenCover
onready var hearths_container = $HearthsContainer
onready var win_label = $WinLabel
onready var lose_label = $Fade/LoseLabel

func _ready():
	fade.color.a = 0
	fade.hide()
	win_label.hide()
	lose_label.hide()
	win_label.text = win_text
	
	PlayerData.connect("max_health_updated", self, "_on_player_max_health_updated")
	PlayerData.connect("health_updated", self, "_on_player_health_updated")

func fade_to_black(with_lose:bool = true):
	fade.show()
	lose_label.modulate = Color.transparent
	fade_tween.interpolate_method(fade, "set_step", -0.2, 1.0, 1.5, Tween.TRANS_SINE, Tween.EASE_IN)
	if with_lose:
		lose_label.show()
		fade_tween.interpolate_property(lose_label, "modulate", Color.transparent, Color.white, 1, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN, 1.0)
	fade_tween.start()

func _reset_hearths():
	var children:Array = hearths_container.get_children()
	for child in children:
		hearths_container.remove_child(child)
		child.queue_free()

func _on_player_max_health_updated(amount:int, current_health:int):
	_reset_hearths()
	for i in amount:
		var new_hearth = hearth_scene.instance()
		hearths_container.add_child(new_hearth)
		new_hearth.id = i+1
	_on_player_health_updated(current_health, amount)


func _on_player_health_updated(amount:int, max_health:int):
	for hearth in hearths_container.get_children():
		hearth.update_hearth(amount, max_health)
	if amount <= 0:
		fade_to_black()


func _on_level_won():
	if !win_label.visible:
		win_label.show()
		fade_to_black(false)
		yield(fade_tween, "tween_all_completed")
		yield(get_tree().create_timer(5.0), "timeout")
		emit_signal("win_animation_finished")


