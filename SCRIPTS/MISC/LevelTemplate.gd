extends Spatial

export(int) var next_level



func _on_water_reached():
	go_to_next_level()

func go_to_next_level():
	Transition.change_scene_to(LevelManager.get_level(next_level))
