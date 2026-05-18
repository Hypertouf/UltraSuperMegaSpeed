extends VehicleBody3D

@export_category("Car Settings")
## max steer in radians for the front wheels- defaults to 0.45
@export var max_steer : float = 0.45
## the maximum torque that the engine will sent to the rear wheels- defaults to 300
@export var max_torque : float = 300.0
## the maximum amount of braking force applied to the wheel. Default is 1.0
@export var max_brake_force : float = 2.0
## the maximum rear wheel rpm. The actual engine torque is scaled in a linear vector to ensure the rear wheels will never go beyond this given rpm.
## The default value is 600rpm
@export var max_wheel_rpm : float = 600.0
## How quickly the wheel responds to player input- equates to seconds to reach maximum steer. Default is 2.0
@export var steer_damping = 2.0
## How sticky are the front wheels. Default is 5. 0 is frictionless._add_constant_central_force
@export var front_wheel_grip : float = 5.0
## How sticky are the rear wheel. Default is 5. Try lower value for a more drift experience
@export var rear_wheel_grip : float = 5.0
@export var torbo : TextureProgressBar
@export var followcamera : Node3D
@export var SLODER : VSlider
@export var hitbox : Area3D

#local member variables
var player_acceleration : float = 0.0
var player_braking : float = 0.0
var player_steer : float = 0.0
var player_input : Vector2 = Vector2.ZERO
var speed = Vector3.ZERO
var total_rotation = Vector3.ZERO
var tricks = [0,0,0]
var default_position = Vector3(0.0,0.0,0.0)
var score = 0
var wheelie = false
var gravity_change = false
#an exporetd array of driving wheels so we can limit rom of each wheel when we process input
@onready var driving_wheels : Array[VehicleWheel3D] = [$WheelBackLeft,$WheelBackRight]
@onready var steering_wheels : Array[VehicleWheel3D] = [$WheelFrontLeft,$WheelFrontRight]



func wheelie_mode() :
	if wheelie :
		max_wheel_rpm = 5000
		max_torque = 600
		
func _ready() -> void:
	#set wheel friction slip
	for wheel in steering_wheels:
		wheel.wheel_friction_slip = front_wheel_grip
	for wheel in driving_wheels:
		wheel.wheel_friction_slip = rear_wheel_grip

func hypothenuse(a, b): #urhm it might look silly but it is necessary for correctly calculating the adaptive FOV
	return sqrt((a*a) + (b*b))

func _input(event): #
	if event.is_action_pressed("sauter"): #car go jump. 
		print("pressed")
		if $check_ground.is_colliding(): #but only if car is on the ground of course
			print("ground_checked")
			$jumpTimer.start(0.1)
			
	if event.is_action_released("sauter") and $check_ground.is_colliding() and $jumpTimer.is_stopped():
		print("big_jump")
		linear_velocity += (transform.basis.y * 6) + transform.basis.z #HOLY SHIT IT WORKS
		linear_velocity.y += 7 #add a little global vertical boost for cleaner walljumps 
				#transform.basis.y + 10 makes the car jump from local position and transform.basis.z makes the car keep it's rolling speed when jumping
				#if we prefer making the car stick to the wall and ceiling use linear_velocity.y += 10
	elif event.is_action_released("sauter") and $check_ground.is_colliding() and !$jumpTimer.is_stopped() :
		print("small_jump")
		linear_velocity += (transform.basis.y * 2) + transform.basis.z #HOLY SHIT IT WORKS
		linear_velocity.y += 3
				
			
	if event.is_action_pressed("nitrous") and torbo.value > 10 :
		#linear_velocity += 25 + (abs(hypothenuse(linear_velocity.x, linear_velocity.z)))
		$nitrous.play() 
		torbo.value -= 25
		followcamera.rotation.y = rotation.y
		linear_velocity += transform.basis.z * 12
	
	if event.is_action_pressed("stomp") and !$check_ground.is_colliding() and torbo.value > 10 :
		$nitrous.play() 
		torbo.value -= 25
		linear_velocity.y = -10
		
		
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	get_input(delta)
	#now process steering and braking
	steering = player_steer
	brake = player_braking
	#cos we want to limit rpm- control each driving wheel individually
	for wheel in driving_wheels:
		#linearly reduce engine force based on the wheels current rpm and the player input
		var actual_force : float = player_acceleration * ((-max_torque/max_wheel_rpm) * abs(wheel.get_rpm()) + max_torque) 
		wheel.engine_force = actual_force
		
	
	followcamera.mycamera.fov = 75 + (abs(hypothenuse(linear_velocity.x, linear_velocity.z))) #adaptive FOV, when the car go faster the FOV go wider to make it feel faster.
																									   #the math used here is simply calculating the hypothenus of the triangle formed by the x axis vector and the z axis vector. this allows the fov adaptation to remain stable no matter the direction in which the car is turning.
																									   # calculating the absolute of this hypothenus simply makes the fov NOT works backwards when the car is going negative x and z directions.
	if !$check_ground.is_colliding() :
		followcamera.rotation_damping = 0
	elif $check_ground.is_colliding() and $check_ground.global_rotation.x < -1.2 and $check_ground.global_rotation.x > -1.6 and $walljumpTimer.is_stopped():
		followcamera.rotation_damping = 0
		followcamera.rotation_degrees.y += 180 
		$walljumpTimer.start(1)
	elif $check_ground.is_colliding() and $check_ground.global_rotation.x < -1.2 and $check_ground.global_rotation.x > -1.6 and !$walljumpTimer.is_stopped():
		followcamera.rotation_damping = 0
	else :
		followcamera.rotation_damping = 3.11
	
	if gravity_change and (basis.z.dot(linear_velocity) <= 4 or Input.is_action_just_released("sauter")):
		PhysicsServer3D.area_set_param(get_viewport().find_world_3d().space, PhysicsServer3D.AREA_PARAM_GRAVITY_VECTOR, Vector3.DOWN)
		gravity_change = false
		
## sets the variables player_steer, player_brake and player_acceleration based on the player input
func get_input(delta : float):
	#steer first
	player_input.x = Input.get_axis("droite","gauche")
	player_steer = move_toward(player_steer, player_input.x * max_steer,steer_damping * delta)
	#now acceleration and/or braking
	player_input.y = Input.get_axis("back","forward")
	if player_input.y > 0.01:
		#accelerating
		player_acceleration = player_input.y
		player_braking = 0.0
	elif player_input.y < -0.01:
		#we are trying to brake or reverse
		if going_forward():
			#brake
			player_braking = -player_input.y * max_brake_force
			player_acceleration = 0.0
		else:
			#reverse
			player_braking = 0.0
			player_acceleration = player_input.y
	else:
		player_acceleration = 0.0
		player_braking = 0.0
		
	if !$check_ground.is_colliding():
		#if default_position == Vector3(0.0,0.0,0.0):
			#print(rotation_degrees)
			#default_position = rotation_degrees
			#print(default_position)
		#if !car_upside_down: #necessary for now because x.axis cannot go upside down
			#rotation.x += Input.get_axis("backflip","frontflip")* 0.1 #makes the car flip on the x axis when not upside down
		#else :
			#rotation.x += Input.get_axis("frontflip","backflip")* 0.1 #switches the car flip direction when it is upside down so that it continues the flip rotation smoothly
		if (Input.is_action_pressed("frontflip") or Input.is_action_pressed("backflip") or Input.is_action_pressed("shuvleft") or Input.is_action_pressed("shuvright") or Input.is_action_pressed("roll_left") or Input.is_action_pressed("roll_right")) and angular_velocity != Vector3.ZERO:
			angular_velocity = Vector3.ZERO
			
			
		if Input.is_action_pressed("frontflip") :
			speed.x = lerp(speed.x, 0.15, 0.05)
			rotate_object_local(Vector3(1, 0, 0), speed.x)
			total_rotation.x += 1
			if total_rotation.x == 60:
				#print("frontflip !!")
				total_rotation.x = 0
				tricks[0] +=1
		elif Input.is_action_pressed("backflip") :
			speed.x = lerp(speed.x, 0.15, 0.05)
			rotate_object_local(Vector3(1, 0, 0), -speed.x)
			total_rotation.x -= 1
			if total_rotation.x == -60:
				total_rotation.x = 0
				#print("backflipflip !!")
				tricks[0] -=1
		else : 
			speed.x = lerp(speed.x, 0.0, 0.5)
		
		if Input.is_action_pressed("shuvleft") :
			speed.y = lerp(speed.y, 0.15, 0.05)
			total_rotation.y += 1
			#if total_rotationx == 30:
				#print("front shuv")
			if total_rotation.y == 60:
				total_rotation.y = 0
				#print("front 360 !!")
				tricks[1] +=1
		elif Input.is_action_pressed("shuvright") :
			speed.y = lerp(speed.y, 0.15, 0.05)
			total_rotation.y -= 1
			#if total_rotationx == -30 :
				#print("backflip shuv")
			if total_rotation.y == -60:
				total_rotation.y = 0
				#print("backflip 360 !!")
				tricks[1] -=1
		else : 
			speed.y = lerp(speed.y, 0.0, 0.5)
		
		rotation.y += Input.get_axis("shuvright","shuvleft") * speed.y #makes the car do shuv-it rotation on the y axis

		
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
				print("backflip 360 !")
			if tricks == [1,0,0]:
				print("frontflip !")
			if tricks == [-1,0,0]:	
				print("backflipflip !")
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
	
	if !$boostTimer.is_stopped() :
		axis_lock_angular_y = true
		axis_lock_angular_z = true
		for wheel in steering_wheels :
			wheel.wheel_friction_slip = 0.0
			
	else :
		axis_lock_angular_y = false
		axis_lock_angular_z = false
		for wheel in steering_wheels :
			wheel.wheel_friction_slip = 5.0
		
## helper function to see if we are moving forward
func going_forward() -> bool:
	var relative_speed : float = basis.z.dot(linear_velocity.normalized())
	if relative_speed > 0.01:
		return true
	else:
		return false

func _on_hitbox_body_entered(body: Node3D) -> void:
	print(body)
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
			
	if body is bumper :
		body.Meesh.player.play("Trigger")
		print("enter bumper")
		position.y = body.global_position.y + 0.29
		position.x = body.global_position.x
		position.z = body.global_position.z
		linear_velocity.y = body.get_parent_node_3d().bump_y
		linear_velocity.x = body.get_parent_node_3d().bump_x
		linear_velocity.z = body.get_parent_node_3d().bump_z
		
	if body is booster_pad :
		print("enter booster")
		position.y = body.global_position.y + 0.29
		position.x = body.global_position.x
		position.z = body.global_position.z
		rotation = body.global_rotation
		for wheel in steering_wheels :
			wheel.rotation = Vector3(0.0,0.0,0.0)
			wheel.steering = 0.0
		steering = 0.0
		linear_velocity = body.get_parent_node_3d().global_transform.basis.z.normalized() * body.get_parent_node_3d().power
		$boostTimer.start(0.2)
		#test comment

	#if body is loop : #button to switch between three cameras
		#print("LOOP !!!!")
		#$cockpit.make_current()
		


func _on_hitbox_area_entered(area: Area3D) -> void:
	print(area)
	if area is enterLoop :
		$cockpit.fov = 90
		$cockpit.make_current()
	
	if area is enterWall :
		print("WALLING")
		gravity_change = true
		# Set the default gravity direction the x coordinates of the wall.																					
		PhysicsServer3D.area_set_param(get_viewport().find_world_3d().space, PhysicsServer3D.AREA_PARAM_GRAVITY_VECTOR, area.get_parent().global_transform.basis.x * 2)
		

																																			
func _on_hitbox_area_exited(area: Area3D) -> void:
	if area is exitLoop :
		followcamera.mycamera.make_current()
	
	if area is exitWall :
		PhysicsServer3D.area_set_param(get_viewport().find_world_3d().space, PhysicsServer3D.AREA_PARAM_GRAVITY_VECTOR, Vector3.DOWN)
		gravity_change = false
