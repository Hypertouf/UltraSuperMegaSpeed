extends VehicleBody3D

<<<<<<< HEAD
#preload() pour charger à l'avance des fichier dans la scene
#absolute_path, IUD

var car_upside_down = true

const default_rearview_y = 2.611
const default_rearview_z = -4.122

func hypothenuse(a, b):
	return sqrt((a*a) + (b*b))
	
=======
var car_upside_down = true

>>>>>>> 48d2fae (pretty textures)
func _physics_process(delta):
	steering = Input.get_axis("droite","gauche") * 0.4
	engine_force = Input.get_axis("back","forward") * 100
	#print(engine_force)
	#print(rotation.z)
	if rotation.z >= 1.5 or rotation.z <= -1.5 :
		car_upside_down = true
	else :
		car_upside_down = false
	#print($check_ground.is_colliding())
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
	get_viewport().get_camera_3d().fov = 90 + (abs(hypothenuse(linear_velocity.x, linear_velocity.z)) * 2)
	if get_viewport().get_camera_3d() == $rearview:
		get_viewport().get_camera_3d().position.y = default_rearview_y - (abs(hypothenuse(linear_velocity.x, linear_velocity.z))) * 0.05
		get_viewport().get_camera_3d().position.z = default_rearview_z + (abs(hypothenuse(linear_velocity.x, linear_velocity.z))) * 0.1
	#print(hypothenuse(linear_velocity.x, linear_velocity.z))
	
func _input(event):
	if event.is_action_pressed("sauter"):
		print("please why ")
		if $check_ground.is_colliding():
			linear_velocity.y += 10
			
	if event.is_action_pressed("switch"):
		if $cockpit.is_current():
			$cockpit.clear_current(true)
		else:
			$rearview.clear_current(true)
