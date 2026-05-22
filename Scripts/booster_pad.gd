extends RigidBody3D
class_name booster_pad

@export var Colbumper : CollisionShape3D
@export var bumperHitbox : CollisionShape3D
@export var Sound : AudioStreamPlayer3D

func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.get_parent_node_3d() is VehicleBody3D :
		Sound.play()
