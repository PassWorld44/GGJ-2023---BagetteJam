extends CanvasLayer

signal scene_changing()
signal scene_changed()
signal faded_in()
signal faded_out()

export(Array,String) var quotelist

onready var slide = $slide
onready var cover = $Cover


func _ready():
	while true:
		yield(get_tree().create_timer(3),"timeout")
		fade_in()
		yield(get_tree().create_timer(3),"timeout")
		fade_out()
	connect("scene_changing",Strange,"save_variables")
	connect("scene_changing",$Cover/Quote,"set_text",[RandUtils.pick(quotelist)])
	connect("scene_changed",slide,"play")

func change_scene(path:String):
	fade_in()
	yield(self,"faded_in")
	get_tree().change_scene(path)
	yield(get_tree(),"idle_frame")
	emit_signal("scene_changed")
	fade_out()

func change_scene_to(path:PackedScene):
	fade_in()
	yield(self,"faded_in")
	get_tree().change_scene_to(path)
	yield(get_tree(),"idle_frame")
	emit_signal("scene_changed")
	fade_out()

func restart():
	fade_in()
	yield(self,"faded_in")
	get_tree().reload_current_scene()
	fade_out()

func fade_in():
	emit_signal("scene_changing")
	get_tree().paused = true
	slide.play()
	cover.material.get("shader_param/noiseTexture").get("noise").set("seed",RandUtils.randi_range(0,9999))
	cover.self_modulate = Color(0.619608, 0.921569, 1.0)
	cover.material.set("shader_param/edgeColor",Color(1.33,1.33,1.33))
	
	
	var twn = create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	twn.parallel().tween_property(cover.material,"shader_param/progress",0.0,2.0)
	twn.parallel().tween_property(cover.material,"shader_param/edgeThickness",0.25,1.0)
	
	yield(twn,"finished")
	emit_signal("faded_in")
	


func fade_out():
	get_tree().paused = false
	cover.material.get("shader_param/noiseTexture").get("noise").set("seed",RandUtils.randi_range(0,9999))
	cover.material.set("shader_param/edgeColor",Color("a4c1f1"))
	var twn = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	twn.tween_property(cover.material,"shader_param/progress",1.0,3.0)
	twn.parallel().tween_property(cover.material,"shader_param/edgeThickness",0.0,2.0)
#	twn.parallel().tween_property(cover.material,"shader_param/edgeColor",Color("a4c1f1"),2.0)
	yield(get_tree().create_timer(2.0),"timeout")
	emit_signal("faded_out")
	

