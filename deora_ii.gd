extends VehicleBody3D

#preload() pour charger à l'avance des fichier dans la scene
#absolute_path, IUD

var car_upside_down = true #self explained, checks if car upside down for flip reasons

const default_rearview_y = 2.611
const default_rearview_z = -4.122 #both constant used for camera placements

func hypothenuse(a, b): #urhm it might look silly but it is necessary for correctly calculating the adaptive FOV
	return sqrt((a*a) + (b*b))
	

func _physics_process(delta): #for any actions that needs to be checked and repeated every frame
	steering = Input.get_axis("droite","gauche") * 0.4  #makes car go right or left
	engine_force = Input.get_axis("back","forward") * 100 #makes car go forward or backward
	#print(engine_force)
	#print(rotation.z)
	if rotation.z >= 1.5 or rotation.z <= -1.5 : #necessary for backflips and frontflips, the x axis doesn't allow you to flip normally because the values only go in bewteen -1.5 to 1.5 in a 180 rotation. 
		car_upside_down = true					 #so the car needs to have two different state (upside down or not) in which it can do a 180 flip rotation. allowing a full 360 rotation.
	else :
		car_upside_down = false
	#print($check_ground.is_colliding())
	#print(car_upside_down)
	if !$check_ground.is_colliding():
		if !car_upside_down: #necessary for now because x.axis cannot go upside down
			rotation.x += Input.get_axis("back","forward")* 0.1 #makes the car flip on the x axis when not upside down
		else :
			rotation.x += Input.get_axis("forward","back")* 0.1 #switches the car flip direction when it is upside down so that it continues the flip rotation smoothly

		#print(rotation.x)
		rotation.y += Input.get_axis("droite","gauche") * 0.1 #makes the car do shuv-it rotation on the y axis
		#print(rotation.y)
		rotation.z += Input.get_axis("roll_right","roll_left") * 0.1 #makes the car do kickflip rotations on the z axis.
	get_viewport().get_camera_3d().fov = 90 + (abs(hypothenuse(linear_velocity.x, linear_velocity.z)) * 2) #adaptive FOV, when the car go faster the FOV go wider to make it feel faster.
																										   #the math used here is simply calculating the hypothenus of the triangle formed by the x axis vector and the z axis vector. this allows the fov adaptation to remain stable no matter the direction in which the car is turning.
																										   # calculating the absolute of this hypothenus simply makes the fov NOT works backwards when the car is going negative x and z directions.
	if get_viewport().get_camera_3d() == $rearview: #makes the rearview camera also get closer to the car as the FOV gets wider.
		get_viewport().get_camera_3d().position.y = default_rearview_y - (abs(hypothenuse(linear_velocity.x, linear_velocity.z))) * 0.05 
		get_viewport().get_camera_3d().position.z = default_rearview_z + (abs(hypothenuse(linear_velocity.x, linear_velocity.z))) * 0.1
	#print(hypothenuse(linear_velocity.x, linear_velocity.z))
	
	if $check_collision.get_collider() is people :
		print("die die die")
		$check_collision.get_collider().linear_velocity = linear_velocity * 10 #makes the NPC get yeeted at very fast speeds when collided

func _input(event): #
	if event.is_action_pressed("sauter"): #car go jump. 
		print("please why ")
		if $check_ground.is_colliding(): #but only if car is on the ground of course
			linear_velocity.y += 10
			
	if event.is_action_pressed("switch"): #button to switch between two cameras
		if $cockpit.is_current():
			$cockpit.clear_current(true)
		else:
			$rearview.clear_current(true)
