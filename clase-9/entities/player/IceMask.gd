extends Node2D

onready var timer = $Timer

export var tex:Texture 
var positions = []
var positions_remove = []
var offset = Vector2(125.0, 125.0)

func paint_ice(x, y):
	var localIce = to_local(Vector2(x,y)) - offset
	
	for p in positions:
		if abs(localIce.distance_to(p)) < 50:
			return

	positions.push_back(localIce)
	update()
	
	if timer.is_stopped():
		timer.start()
	
	var new_timer = get_tree().create_timer(2.0)
	new_timer.connect("timeout", self, "_animate_erase")

func _animate_erase():
	var point = positions.pop_front()
	var size:Vector2 = Vector2(255, 255)
	var rect:Rect2 = Rect2(point, size)
	positions_remove.push_back(rect)
	update()

func _draw():
	for p in positions:
		draw_texture(tex, p)
	for rect in positions_remove:
		draw_texture_rect(tex, rect, false)

func _remove_pos(pos):
	positions_remove.erase(pos)
	if positions_remove.empty() && positions.empty():
		timer.stop()

func _on_Timer_timeout():
	var new_list:Array = []
	for rect in positions_remove:
		var size:Vector2 = rect.size
		size.x = max(size.x - 4, 0)
		size.y = max(size.y - 4, 0)
		rect.position += Vector2(2, 2)
		rect.size = size
		new_list.append(rect)
		if size == Vector2.ZERO:
			call_deferred("_remove_pos", rect)
	positions_remove = new_list
	update()
