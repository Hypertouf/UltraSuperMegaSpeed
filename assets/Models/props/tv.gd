extends RigidBody3D

@export var mesh : MeshInstance3D
@export var anim : AnimationPlayer
@export var intact : Mesh
@export var broke : Mesh
@export var light : SpotLight3D
@export var sound : AudioStreamPlayer3D
@export var explosion : AudioStreamMP3
@export var parti : GPUParticles3D
@export var text : Sprite3D
var izdead : bool = false

func _ready() -> void:
	anim.play("Idle_noise")
	pass


func _on_area_3d_area_entered(area: Area3D) -> void:
	
	if area.name == "hitbox" and izdead == false:
		izdead = true
		parti.emitting = true
		linear_velocity = area.get_parent().linear_velocity *1.5
		sound.stream = explosion
		sound.play()
		light.light_energy = 0
		anim.stop()
		text.visible = false
		mesh.mesh = broke
		var timy = Timer.new() # Create a new Sprite2D.
		timy.autostart = true
		timy.wait_time = 1
		timy.timeout.connect(_ontimyended)
		add_child(timy) # Add it as a child of this node.
		pass
	
	pass # Replace with function body.

func _ontimyended():
	parti.emitting = false
	
	pass
