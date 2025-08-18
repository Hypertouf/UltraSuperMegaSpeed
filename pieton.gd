extends Node3D

@export var PietonMESH : Mesh
@export var mesh : Node3D
@export var explo : MeshInstance3D
@export_enum("Good", "Bad", "Osef") var Karma: int


func _ready() -> void:
	mesh.mesh = PietonMESH

	pass
