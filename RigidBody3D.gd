extends RigidBody3D


# Called when the node enters the scene tree for the first time.
func _ready():
	print(get_tree().get_root().get_camera_3d())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_dragable_drag_start(node):
	pass # Replace with function body.


func _on_dragable_drag_move(node, cast):
	position = Vector3(cast.position.x, 0.2, cast.position.z)
	pass # Replace with function body.
