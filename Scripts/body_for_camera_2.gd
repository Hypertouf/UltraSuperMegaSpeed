extends StaticBody3D

@export var car : VehicleBody3D

func _process(delta: float) -> void:
	position = car.position
