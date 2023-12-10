extends RigidBody3D

#:= -> для ускорения кода, программа понимает, что float
var speed_player := 100000.0
var mouse_sensivity := 0.001
var twist_input := 0.0
var pitch_input := 0.0
var max_angle := 0.75 #radians



# @onready связывает переменные с Node, которые недоступны в данном окружении
@onready var twist_pivot := $TwistPivot
@onready var pitch_pivot := $TwistPivot/PitchPivot

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	var input := Vector3.ZERO
	input.x = Input.get_axis("ui_left", "ui_right")
	input.z = Input.get_axis("ui_up", "ui_down")
	apply_central_force(twist_pivot.basis * input * speed_player * delta)
	twist_pivot.rotate_y(twist_input)
	pitch_pivot.rotate_x(pitch_input)
	#clamp - если ниже нижней границы, то значение поворота становится = -max_angle
	pitch_pivot.rotation.x = clamp(pitch_pivot.rotation.x, -max_angle-.3, max_angle)
	twist_input = 0.0
	pitch_input = 0.0
	
		#transform = transform.orthonormalized()
	#if transform.basis.y.normalized().cross(get_gravity_dir_vector()) != Vector3():
	#	look_at(planet.global_transform.origin, transform.basis.y)
	#if transform.basis.x.normalized().cross(get_gravity_dir_vector()) != Vector3():
	#	look_at(planet.global_transform.origin, transform.basis.x) 
	
#func get_gravity_dir_vector():
	#return (planet.transform.origin - transorm.origin).normalized()
	

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			twist_input = -event.relative.x * mouse_sensivity
			pitch_input = -event.relative.y * mouse_sensivity
