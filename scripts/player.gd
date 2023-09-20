extends CharacterBody3D

@onready var head = $Head

const  MOUSE_SENSIBILITY := 0.4
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var direction = Vector3.ZERO

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		self.rotate_y(deg_to_rad(-event.relative.x * MOUSE_SENSIBILITY))
		head.rotate_x(deg_to_rad(-event.relative.y * MOUSE_SENSIBILITY))
		head.rotation.x = clamp(head.rotation.x,deg_to_rad(-89),deg_to_rad(89))


func _physics_process(delta: float) -> void:
	var input_dir = Input.get_vector("left","right","forward","backward")
	direction = lerp(direction,(transform.basis * Vector3(input_dir.x,0,input_dir.y).normalized()),delta * 10)
	
	if !is_on_floor():
		velocity.y -= gravity * delta
		
	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x,0,SPEED)
		velocity.z = move_toward(velocity.z,0,SPEED)
		



	move_and_slide()
