extends Sprite

signal focus_changed(new_focus)

# Control node to get current focus owner
var verifier : Control

# Sine wave movement handling
var time = 0
var freq = 4
var amplitude = 8
onready var base_offset_x = offset.x

# Focus handling

var current_focus : Control 

var next_position : Vector2 = Vector2.ZERO

func _enter_tree():
	verifier = Control.new()
	add_child(verifier)




func _process(delta):
	# moving in a sine wave horizontally
	
	
	time += delta
	var offset_x = base_offset_x-abs((sin(time * freq) * amplitude))
	offset.x = lerp(offset.x,offset_x,0.5)
	
	if not is_valid(get_focus_owner()):
		hide()
		return
	show()
	if get_focus_owner().has_signal("pressed"):
		if not get_focus_owner().is_connected("pressed",self,"_focus_pressed"):
			update_focus()
	global_position = lerp(global_position,get_side_position(),0.15)


# Custom methods

func update_focus():
	get_focus_owner().connect("pressed",self,"_focus_pressed")
	if is_instance_valid(current_focus):
		if current_focus.has_signal("pressed"):
			if current_focus.is_connected("pressed",self,"_focus_pressed"):
				current_focus.disconnect("pressed",self,"_focus_pressed")
	current_focus = get_focus_owner()

# Rolling and blinking red
func _focus_pressed():
	print("boop",current_focus.name)

func cannot_press():
	var twn = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	twn.tween_property(self,"modulate:g",0.0,0.1)
	twn.parallel().tween_property(self,"modulate:b",0.0,0.1)
	twn.parallel().tween_property(self,"rotation_degrees",rotation_degrees,stepify(rotation_degrees+360,360),0.5)
	twn.parallel().tween_property(self,"modulate:g",1.0,0.4).set_delay(0.1)
	twn.parallel().tween_property(self,"modulate:b",1.0,0.4).set_delay(0.1)

# Setters & Getters

func get_focus_owner() -> Control:
	return verifier.get_focus_owner()

func get_side_position():
	var overflow = get_focus_owner().rect_global_position.x < texture.get_size().x*2
	
	flip_h = overflow
	return get_focus_owner().rect_global_position + Vector2(get_focus_owner().rect_size.x + texture.get_size().x/2 if overflow else -texture.get_size().x/2 ,
	get_focus_owner().rect_size.y/2)

func is_valid(node:Control):
	return is_instance_valid(node) && not node.is_in_group("unfocusable")
