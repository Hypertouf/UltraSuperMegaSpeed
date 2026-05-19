extends VehicleBody3D
class_name DeoraII
#preload() pour charger à l'avance des fichier dans la scene
#absolute_path, IUD
@export var SLODER : VSlider
@export var Timy : Timer
@export var torbo : TextureProgressBar
@export var hitbox : Area3D
@export var locked_cam : Camera3D

var car_upside_down = true #self explained, checks if car upside down for flip reasons

var speed = Vector3.ZERO
var score
var total_rotation = Vector3.ZERO
var default_position = Vector3(0.0,0.0,0.0)
var tricks = [0,0,0]

const default_rearview_y = 2.611
const default_rearview_z = -4.122 #both constant used for camera placements

func hypothenuse(a, b): #urhm it might look silly but it is necessary for correctly calculating the adaptive FOV
	return sqrt((a*a) + (b*b))
	

func _physics_process(delta): #for any actions that needs to be checked and repeated every frame
	#print(abs(hypothenuse(linear_velocity.x, linear_velocity.z)))
	steering = Input.get_axis("droite","gauche") * 0.4  #makes car go right or left
	if $Timer.is_stopped() and (abs(hypothenuse(linear_velocity.x, linear_velocity.z)) < 40.0):
		engine_force = Input.get_axis("back","forward") * 200 #makes car go forward or backward
	elif $Timer.is_stopped() and abs(hypothenuse(linear_velocity.x, linear_velocity.z)) >= 40.0:
		engine_force=0

	#if rotation.z >= 1.5 or rotation.z <= -1.5 : #necessary for backflips and frontflips, the x axis doesn't allow you to flip normally because the values only go in bewteen -1.5 to 1.5 in a 180 rotation. 
		#car_upside_down = true					 #so the car needs to have two different state (upside down or not) in which it can do a 180 flip rotation. allowing a full 360 rotation.
	#else :
		#car_upside_down = false

	if !$check_ground.is_colliding():
		#if default_position == Vector3(0.0,0.0,0.0):
			#print(rotation_degrees)
			#default_position = rotation_degrees
			#print(default_position)
		#if !car_upside_down: #necessary for now because x.axis cannot go upside down
			#rotation.x += Input.get_axis("back","forward")* 0.1 #makes the car flip on the x axis when not upside down
		#else :
			#rotation.x += Input.get_axis("forward","back")* 0.1 #switches the car flip direction when it is upside down so that it continues the flip rotation smoothly
		if (Input.is_action_pressed("forward") or Input.is_action_pressed("back") or Input.is_action_pressed("gauche") or Input.is_action_pressed("droite") or Input.is_action_pressed("roll_left") or Input.is_action_pressed("roll_right")) and angular_velocity != Vector3.ZERO:
			angular_velocity = Vector3.ZERO
			
			
		if Input.is_action_pressed("forward") :
			speed.x = lerp(speed.x, 0.15, 0.05)
			rotate_object_local(Vector3(1, 0, 0), speed.x)
			total_rotation.x += 1
			if total_rotation.x == 60:
				#print("frontflip !!")
				total_rotation.x = 0
				tricks[0] +=1
		elif Input.is_action_pressed("back") :
			speed.x = lerp(speed.x, 0.15, 0.05)
			rotate_object_local(Vector3(1, 0, 0), -speed.x)
			total_rotation.x -= 1
			if total_rotation.x == -60:
				total_rotation.x = 0
				#print("backflip !!")
				tricks[0] -=1
		else : 
			speed.x = lerp(speed.x, 0.0, 0.5)
		
		if Input.is_action_pressed("gauche") :
			speed.y = lerp(speed.y, 0.15, 0.05)
			total_rotation.y += 1
			#if total_rotationx == 30:
				#print("front shuv")
			if total_rotation.y == 60:
				total_rotation.y = 0
				#print("front 360 !!")
				tricks[1] +=1
		elif Input.is_action_pressed("droite") :
			speed.y = lerp(speed.y, 0.15, 0.05)
			total_rotation.y -= 1
			#if total_rotationx == -30 :
				#print("back shuv")
			if total_rotation.y == -60:
				total_rotation.y = 0
				#print("back 360 !!")
				tricks[1] -=1
		else : 
			speed.y = lerp(speed.y, 0.0, 0.5)
		
		rotation.y += Input.get_axis("droite","gauche") * speed.y #makes the car do shuv-it rotation on the y axis

		
		if Input.is_action_pressed("roll_left") :
			speed.z = lerp(speed.z, 0.15, 0.05)
			total_rotation.z += 1
			if total_rotation.z == 60:
				total_rotation.z = 0
				#print("heelflip !!")
				tricks[2] += 1
		elif Input.is_action_pressed("roll_right") :
			speed.z = lerp(speed.z, 0.15, 0.05)
			total_rotation.z -= 1
			if total_rotation.z == -60:
				total_rotation.z = 0
				#print("kickflip !!")
				tricks[2] -=1
		else : 
			speed.z = lerp(speed.z, 0.0, 0.5)
		
		rotation.z += Input.get_axis("roll_right","roll_left") * speed.z #makes the car do kickflip rotations on the z axis.
		
		#print(default_position)
		#print(default_position.y - rotation_degrees.y)
		#print(total_rotationx)
		if (default_position.y - rotation_degrees.y) >= 180	: #I need to learn about transformation matrix ugh
			#print("shuvit !!!")
			default_position = Vector3(0,0,0)

	if $check_ground.is_colliding():
		#print("it's non the ground")
		if tricks != [0,0,0]:
			print(tricks)
			if tricks == [0,1,0] :
				print("front 360 !")
			if tricks == [0,-1,0] :
				print("back 360 !")
			if tricks == [1,0,0]:
				print("frontflip !")
			if tricks == [-1,0,0]:	
				print("backflip !")
			if tricks == [0,0,-1]:
				print("kickflip !")
			if tricks == [0,0,1]:
				print("heelflip !")
			if tricks == [0,-1,-1]:
				print("360 flip !!!")
			if tricks == [0,1,1]:
				print("360 hardflip !!!")
			if tricks == [0,1,-1]:
				print("360 heelflip !!!")
			if tricks == [0,-1,1]:
				print("360 inward heelfip !!!")
			
			score = abs(tricks[0]) + abs(tricks[1]) + abs(tricks[2])
			print(score)
			torbo.value += score * 10
				
		tricks = [0,0,0]
		default_position = Vector3(0,0,0)
		total_rotation = Vector3.ZERO
	#print(get_viewport().get_camera_3d().fov)
	#if get_viewport().get_camera_3d().fov < 150 :
	get_viewport().get_camera_3d().fov = 90 + (abs(hypothenuse(linear_velocity.x, linear_velocity.z))) #adaptive FOV, when the car go faster the FOV go wider to make it feel faster.
																									   #the math used here is simply calculating the hypothenus of the triangle formed by the x axis vector and the z axis vector. this allows the fov adaptation to remain stable no matter the direction in which the car is turning.
																									   # calculating the absolute of this hypothenus simply makes the fov NOT works backwards when the car is going negative x and z directions.

	if get_viewport().get_camera_3d() == $rearview: #makes the rearview camera also get closer to the car as the FOV gets wider.
		get_viewport().get_camera_3d().position.y = default_rearview_y - (abs(hypothenuse(linear_velocity.x, linear_velocity.z))) * 0.02 
		get_viewport().get_camera_3d().position.z = default_rearview_z + (abs(hypothenuse(linear_velocity.x, linear_velocity.z))) * 0.05
	
		
func _input(event): #
	if event.is_action_pressed("sauter"): #car go jump. 
		#print("please why ")
		if $check_ground.is_colliding(): #but only if car is on the ground of course
			linear_velocity.y += 10
		
		
	if event.is_action_pressed("switch"): #button to switch between three cameras
		if $cockpit.is_current():
			$rearview.make_current()
		elif $rearview.is_current():
			$behind.make_current()
		elif $behind.is_current() : 
			locked_cam.make_current()
		else :
			$cockpit.make_current()
	
	if event.is_action_pressed("nitrous") and torbo.value > 10 :
		#linear_velocity += 25 + (abs(hypothenuse(linear_velocity.x, linear_velocity.z)))
		$nitrous.play() 
		torbo.value -= 25
		$Timer.start(0.25)
		if !$Timer.is_stopped():
			engine_force = 1000

		
		

func _on_hitbox_body_entered(body: Node3D) -> void:
		if body is people :
			print("die die die")
			$explo.play()
			body.get_parent().explo.position = body.position
			body.linear_velocity = linear_velocity * 10 #makes the NPC get yeeted at very fast speeds when collided
			body.boom.play("Boom")
			
			if body.get_parent().Karma == 0 :
				
				SLODER.value += 5
				self.get_parent()._radio_start("Child_good")
				pass
				
			if body.get_parent().Karma == 1 :
				
				SLODER.value -= 5
				self.get_parent()._radio_start("Child_bad")
				pass

			if body.get_parent().Karma == 2 :
				self.get_parent()._radio_start("Child_neutral")
				pass
