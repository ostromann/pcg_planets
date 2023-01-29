tool
extends Resource
class_name PlanetNoise

export var enabled : bool = true setget set_enabled
export var noise_map : OpenSimplexNoise setget set_noise_map
export var amplitude : float = .1 setget set_amplitude
export var min_value : float = -1.0 setget set_min_value
export var max_value : float = 1.0 setget set_max_value
export var use_mask : bool = false setget set_use_mask
export var mask_layer : int = 0 setget set_mask_layer
export var mask_threshold : float = 0.0 setget set_mask_threshold
export var mask_curve : Curve setget set_mask_curve
export var flip_mask : bool = true setget set_flip_mask

func set_mask_curve(val):
	mask_curve = val
	emit_signal("changed")
	if mask_curve != null and not mask_curve.is_connected("changed", self, "on_data_changed"):
		mask_curve.connect("changed", self, "on_data_changed")
	

func set_min_value(val):
	if val > max_value:
		val = max_value
	min_value = val
	emit_signal("changed")
	
func set_max_value(val):
	if val < min_value:
		val = min_value
	max_value = val
	emit_signal("changed")

func set_noise_map(val):
	noise_map = val
	emit_signal("changed")
	if noise_map != null and not noise_map.is_connected("changed", self, "on_data_changed"):
		noise_map.connect("changed", self, "on_data_changed")

func set_enabled(val):
	enabled = val
	emit_signal("changed")
	
func set_use_mask(val):
	use_mask = val
	emit_signal("changed")

func set_mask_layer(val):
	if val < 0:
		val = 0
	mask_layer = val
	emit_signal("changed")
	
func set_mask_threshold(val):
	mask_threshold = val
	emit_signal("changed")

func set_flip_mask(val):
	flip_mask = val
	print('mask flipped')
	emit_signal("changed")

func set_amplitude(val):
	amplitude = val
	emit_signal("changed")
	
func on_data_changed():
	emit_signal("changed")
	
func get_value_at_point(point_on_sphere : Vector3) -> float:
	var noise_val  = noise_map.get_noise_3dv(point_on_sphere * 100) * amplitude
	return clamp(noise_val, min_value, max_value)
	
func get_masked_value_at_point(mask_noise_layer : PlanetNoise, point_on_sphere : Vector3) -> float:
	var mask_val = mask_noise_layer.get_value_at_point(point_on_sphere)
	if flip_mask:
		mask_val = -mask_val
	var noise_val  = noise_map.get_noise_3dv(point_on_sphere * 100) * amplitude
	noise_val = noise_val * mask_curve.interpolate_baked(mask_val)
	return clamp(noise_val, min_value, max_value)

func is_masked(mask_noise_layer : PlanetNoise, point_on_sphere : Vector3) -> bool:
	"""
	Return 'true' if this noise layer is masked by the input 'mask_noise_layer' at the given 'point_on_sphere'
	"""
	var is_masked = false
	if not flip_mask:
		if mask_noise_layer.get_value_at_point(point_on_sphere) < mask_threshold:
			is_masked = true
	else:
		if mask_noise_layer.get_value_at_point(point_on_sphere) > mask_threshold:
			is_masked = true
	return is_masked
