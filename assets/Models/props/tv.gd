extends RigidBody3D


func _on_body_entered(body: Node) -> void:
	if body.get_class() == "VehicleBody3D" :
		print ("AAAAAH")
		pass
	pass # Replace with function body.
