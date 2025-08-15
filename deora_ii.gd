extends VehicleBody3D
var car_upside_down = true
func _physics_process(delta):
	steering = Input.get_axis("droite","gauche") * 0.4
	engine_force = Input.get_axis("back","forward") * 100
	#print(engine_force)
	#print(rotation.z)
	if rotation.z >= 1.5 or rotation.z <= -1.5 :
		car_upside_down = true
	else :
		car_upside_down = false
	print($check_ground.is_colliding())
	#print(car_upside_down)
	if !$check_ground.is_colliding():
		if !car_upside_down: #necessary for now because x.axis cannot go upside down
			rotation.x += Input.get_axis("back","forward")* 0.1#max values between -1.5 and 1.5; -1.5 to 0 is car upside down, 0 to 1.5 is car upright
		else :
			rotation.x += Input.get_axis("forward","back")* 0.1#max values between -1.5 and 1.5; -1.5 to 0 is car upside down, 0 to 1.5 is car upright

		#print(rotation.x)
		rotation.y += Input.get_axis("droite","gauche") * 0.1
		#print(rotation.y)
		rotation.z += Input.get_axis("roll_right","roll_left") * 0.1
		
	$Camera3D.fov = 90 + (abs(max(linear_velocity.x, linear_velocity.z)) * 3)

func _input(event):
	if event.is_action_pressed("sauter"):
		print("please why ")
		if $check_ground.is_colliding():
			linear_velocity.y += 10
