extends KinematicBody


export var damage = 100


var gravity = 9.8
var Speed = 100
var acceleration = 5
var jump = 6

var velocity = Vector3()
var direction = Vector3()
var fall = Vector3()
var jumpstatex = 1
var mouse_sensitivity = 0.15


onready var head = $head
onready var maincam = $Maincam
onready var pivot = $pivot 
onready var aimcast =$head/Camera/aimcast
onready var bullethole = preload("res://bullethole.tscn")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass # Replace with function body.


func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		pivot.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
		pivot.rotation.x = clamp(pivot.rotation.x , deg2rad(-60), deg2rad(60))
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		head.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
		head.rotation.x = clamp(head.rotation.x , deg2rad(-60), deg2rad(60))
	if Input.is_action_just_pressed("click"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
	direction = Vector3()
	
	if not is_on_floor():
		fall.y -= gravity * delta
		
	
	if Input.is_action_just_pressed("jump") and  is_on_floor():
		fall.y = jump

	
		
	if Input.is_action_pressed("up"):
		
		direction -= transform.basis.z
		
	elif Input.is_action_pressed("down"):
		
		direction += transform.basis.z
	if Input.is_action_pressed("left"):
		
		direction -= transform.basis.x
	elif Input.is_action_pressed("right"):
		
		direction += transform.basis.x
	
	direction = direction.normalized()
	
	velocity = direction * Speed
	
	velocity .linear_interpolate(velocity , acceleration * delta)
	move_and_slide(velocity, Vector3.UP)
	move_and_slide(fall , Vector3.UP)
	
	
	
	if Input.is_action_pressed("shoot"):
		if aimcast.is_colliding():
			var target = aimcast.get_collider()
			if target.is_in_group("enemy"):
				target.health -= damage
		var b = bullethole.instance()
		get_tree().get_root().add_child(b)
		b.global_transform.origin = aimcast.get_collision_point()
		b.look_at(aimcast.get_collision_point() + aimcast.get_collision_normal(), Vector3.UP)
