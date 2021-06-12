tool
extends Node

const enemy_spawner_resource = preload("res://entities/enemies/EnemySpawnPoint.tscn")
const pathfind_resource = preload("res://entities/pathfinding/PathfindA.tscn")

export (bool) var generate_spawn setget set_generate_spawn
export (bool) var generate_pathfind setget set_generate_pathfind

export (NodePath) var pathfind_path

# Execution on editor
func set_generate_spawn(value):
	generate_spawn = false
	if value:
		_create_spawn_point_for_editor()

func _create_spawn_point_for_editor():
	if !Engine.editor_hint:
		return
	
	var new_spawn:EnemySpawnPoint = enemy_spawner_resource.instance()
	add_child(new_spawn)
	new_spawn.set_owner(get_tree().get_edited_scene_root())

func set_generate_pathfind(value):
	generate_pathfind = false
	if value && Engine.editor_hint:
		var pathfind_node = pathfind_resource.instance()
		add_child(pathfind_node)
		pathfind_node.set_owner(get_tree().get_edited_scene_root())

## Execution on runtime
func _ready():
	if !Engine.editor_hint:
		call_deferred("_initialize")

func _initialize():
	var visible_rect:Rect2 = get_viewport().get_visible_rect()
	var pathfind = get_node(pathfind_path)
	for child in get_children():
		if child is EnemySpawnPoint:
			child.spawn(pathfind)
