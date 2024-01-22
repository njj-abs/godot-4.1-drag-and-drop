extends Node

export (float) var ray_length = 100

var draggables = []
var camera: Camera
var draging: Node  # Explicitly specify type for clarity

func _ready():
    camera = get_tree().root.get_child(Camera)  # Updated tree traversal
    set_physics_process(false)

func register_draggable(node: Node):
    draggables.append(node)
    node.connect("drag_start", self, "_drag_start")
    node.connect("drag_stop", self, "_drag_stop")

func _drag_start(node: Node):  # Indicate node type for clarity
    draging = node
    set_physics_process(true)

func _drag_stop(node: Node):  # Indicate node type for clarity
    draging = null
    set_physics_process(false)

func _physics_process(delta):
    var mouse = get_viewport().get_mouse_position()
    var from = camera.project_ray_origin(mouse)
    var to = from + camera.project_ray_normal(mouse) * ray_length

    var cast = PhysicsServer.space_get_direct_state(
        camera.get_world().space
    ).intersect_ray(from, to, [draging.get_parent()], draging.get_parent().get_collision_mask(), true, true)
    if not cast.empty():
        draging.on_hover(cast)
