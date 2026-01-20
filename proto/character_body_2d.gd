extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const FLY_SPEED = 300.0
const rotation_speed = 5.0

@export var air_drag: float = 0.95        # Slows horizontal speed when not jetting
@export var gravity: float = 1200.0       # Gravity strength


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var move_direction := Input.get_axis("ui_left", "ui_right")
	if move_direction:
		velocity.x = move_direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var mouse_pos = get_global_mouse_position()
		var fly_direction = -(mouse_pos - global_position).normalized()
		velocity = fly_direction * FLY_SPEED
		#current_fuel -= delta
		rotation = fly_direction.angle() + deg_to_rad(90)
	else:
		velocity.y += gravity * delta
		velocity.x *= air_drag
		if velocity.length() > 0:
			var target_angle = velocity.angle() - deg_to_rad(90)
			rotation = lerp_angle(rotation, target_angle, rotation_speed * delta)
		
	move_and_slide()
