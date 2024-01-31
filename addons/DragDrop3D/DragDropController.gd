extends Node3D

var ray_length = 100

var draggables = []
var camera: Camera3D
var draging

func _ready():
	camera = get_tree().get_root().get_camera_3d()
	set_physics_process(false)

func register_draggable(node):
	draggables.append(node)
	node.connect("drag_start",Callable(self,"_drag_start"))
	node.connect("drag_stop", Callable(self,"_drag_stop"))
	
func _drag_start(node):
	draging = node
	set_physics_process(true)
	
func _drag_stop(node):
	set_physics_process(false)

func _physics_process(delta):
	var mouse = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mouse)
	var to = from + camera.project_ray_normal(mouse) * ray_length
	var space = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.from = from
	ray_query.to = to
	var cast = space.intersect_ray(ray_query)
	if not cast.is_empty():
		draging.on_hover(cast)
