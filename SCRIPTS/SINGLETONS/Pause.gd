extends CanvasLayer

signal paused()
signal unpaused()

onready var cover = $Cover

func _ready():
	connect("unpaused",get_tree(),"set",["paused",false])
	connect("paused",get_tree(),"set",["paused",true])
	$FocusCursor.set_process(false)

func _input(event):
	if event.is_action_pressed("ui_pause"):
		toggle_pause()

func pause():
	emit_signal("paused")
	print("has been paused")
	$FocusCursor.set_process(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	

func unpause():
	emit_signal("unpaused")
	print("HAS BEEN UNPAUSED")
	$FocusCursor.set_process(false)
	if get_tree().current_scene is Spatial:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	

func toggle_pause():
	unpause() if get_tree().paused else pause()


func quit():
	Strange.save_variables()
	yield(get_tree(),"idle_frame")
	get_tree().quit()


func show_settings():
	Settings.show()

func go_to_titlescreen():
	Transition.change_scene("res://SCENES/UI/MENU/Menu.tscn")
