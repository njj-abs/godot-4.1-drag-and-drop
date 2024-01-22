extends RigidBody3D

var camera: Camera3D

# Called when the node enters the scene tree for the first time.
func _ready():
	print(get_tree().get_root().get_camera_3d())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
