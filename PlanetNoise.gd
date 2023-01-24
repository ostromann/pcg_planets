tool
extends Resource
class_name PlanetNoise

export var noise_map : OpenSimplexNoise setget set_noise_map
export var amplitude : float = 1.0 setget set_amplitude
export var min_elevation : float = 0.0 setget set_min_elevation
export var max_elevation : float = 2.0 setget set_max_elevation
export var use_first_layer_as_mask : bool = false setget set_use_first_layer_as_mask

func set_min_elevation(val):
	if val > max_elevation:
		val = max_elevation
	min_elevation = val
	emit_signal("changed")
	
func set_max_elevation(val):
	if val < min_elevation:
		val = min_elevation
	max_elevation = val
	emit_signal("changed")

func set_noise_map(val):
	noise_map = val
	emit_signal("changed")
	if noise_map != null and not noise_map.is_connected("changed", self, "on_data_changed"):
		noise_map.connect("changed", self, "on_data_changed")
		
func set_amplitude(val):
	amplitude = val
	emit_signal("changed")
	
func set_use_first_layer_as_mask(val):
	use_first_layer_as_mask = val
	emit_signal("changed")

func on_data_changed():
	emit_signal("changed")
