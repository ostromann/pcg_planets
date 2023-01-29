tool
extends Resource

class_name PlanetData

export var radius := 1.0 setget set_radius
export var resolution := 5 setget set_resolution
export(Array, Resource) var planet_noise setget set_planet_noise
export var planet_color : GradientTexture setget set_planet_color

var min_elevation := 9999.9
var max_elevation := 0.0


func set_radius(val):
	radius = val
	emit_signal("changed")

func set_resolution(val):
	resolution = val
	emit_signal("changed")
	
func set_planet_noise(val):
	planet_noise = val
	emit_signal("changed")
	for n in planet_noise:
		if n != null and not n.is_connected("changed", self, "on_data_changed"):
			n.connect("changed", self, "on_data_changed")

func set_planet_color(val):
	planet_color = val
	emit_signal("changed")
	if planet_color != null and not planet_color.is_connected("changed", self, "on_data_changed"):
		planet_color.connect("changed", self, "on_data_changed")

func on_data_changed():
	emit_signal("changed")

func point_on_planet(point_on_sphere : Vector3) -> Vector3:
	var elevation : float = 0.0
	for n in planet_noise:
		if not n.enabled:
			continue
		if n.use_mask:
			if n.mask_layer >= planet_noise.size():
				pass
			else:
				elevation += n.get_masked_value_at_point(planet_noise[n.mask_layer], point_on_sphere)
		else:
			elevation += n.get_value_at_point(point_on_sphere)
		
	return point_on_sphere * radius * (elevation + 1.0)


