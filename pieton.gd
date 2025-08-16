extends Node3D

@export var texture : Texture
@export var mesh : Node3D

func _ready() -> void:
	mesh.mesh.material.albedo_texture = texture
	pass
