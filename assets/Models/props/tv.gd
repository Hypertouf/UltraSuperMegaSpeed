extends RigidBody3D

@export var mesh : MeshInstance3D
@export var anim : AnimationPlayer
@export var intact : Mesh
@export var broke : Mesh


func _ready() -> void:
	anim.play("Idle_noise")
	pass


func _on_area_3d_area_entered(area: Area3D) -> void:
	
	if area.name == "hitbox" :
		anim.stop()
		mesh.mesh = broke
		pass
	
	pass # Replace with function body.
