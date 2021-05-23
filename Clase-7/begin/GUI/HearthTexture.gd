extends TextureRect

export (Texture) var hearth_full
export (Texture) var hearth_empty

var id

func update_hearth(current_health:int, max_health:int):
	visible = id <= max_health
	texture = hearth_full if id <= current_health else hearth_empty
	
