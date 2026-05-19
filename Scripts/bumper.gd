extends RigidBody3D
class_name bumper

@export var Colbumper : CollisionShape3D
@export var Meesh : Node3D
@export var Sound : AudioStreamPlayer3D


func _on_area_3d_area_entered(area: Area3D) -> void:
	Sound.play()
