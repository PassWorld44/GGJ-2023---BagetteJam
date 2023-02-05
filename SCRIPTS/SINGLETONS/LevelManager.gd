extends Node

#const level_folder = "res://SCENES/LEVELS/"

export(Array,PackedScene) var levels = []

const menu = preload("res://SCENES/UI/MENU/Menu.tscn")

#func _ready():
#	levels = get_level_list()
#	print(levels)

func get_level(_level:int):
	return levels[_level-1] if _level-1 <= levels.size()-1 else menu

#func get_level_list() -> Array:
#	var regex = RegEx.new()
#	regex.compile("^(level)[0-9]")
#	var level_list = []
#	var dir : Directory = Directory.new()
#	dir.open(level_folder)
#	dir.list_dir_begin()
#	while true:
#		var file = dir.get_next()
#		if file == "":
#			break
#		elif not file.begins_with("."):
#			if file.ends_with(".tscn"):
#				var result = regex.search(file.to_lower())
#				var new_level = load(level_folder+file)
#				if result && not new_level in level_list:
#					level_list.append(new_level)
#	dir.list_dir_end()
#
#	return level_list
