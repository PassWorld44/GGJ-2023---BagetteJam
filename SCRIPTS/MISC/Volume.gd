extends HSlider

class_name VolumeSlider

export(int,0,3) var bus
export(float,-40,0) var base_volume
export(NodePath) var label_node
export(String) var prefix = "Volume = "
onready var label : Label = get_node(label_node)


func _ready():
	connect("value_changed",self,"_on_value_changed")
	
	if AudioStreamPlayer in get_children():
		# warning-ignore:return_value_discarded
		connect("focus_entered",get_child(0),"play")
		# warning-ignore:return_value_discarded
		connect("focus_exited",get_child(0),"stop")
	
	value = range_lerp(Strange.get_bus_volume(bus),-40,base_volume,0,100)
	label.set_text(str(value))
	AudioServer.set_bus_volume_db(bus,Strange.get_bus_volume(bus))
	
	# warning-ignore:return_value_discarded
	
	

func _on_value_changed(value):
	if value <= min_value:
		AudioServer.set_bus_mute(bus,true)
	else:
		AudioServer.set_bus_mute(bus,false)
	
	label.set_text(prefix + str(value))
	
	value = range_lerp(value,0,100,-40,base_volume)
	
	AudioServer.set_bus_volume_db(bus,value)
	Strange.set_bus_volume(bus,value)

