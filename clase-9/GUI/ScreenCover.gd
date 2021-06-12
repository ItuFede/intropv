extends ColorRect

func reset():
	pass

func set_step(amount:float):
	material.set_shader_param("step_start", min(amount, 1.0))
