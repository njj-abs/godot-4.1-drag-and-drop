tool
extends Node

class_name Draggable

signal dragStart(node)
signal dragStop(node)
signal dragMove(node, cast)

export (int, 0,19) var bit = 19
export var dragStartFn = "onDraggableDragStart"
export var dragStopFn = "onDraggableDragStop"
export var dragMoveFn = "onDraggableDragMove"

onready var controller = DragDropController
onready var area_layer = get_parent().get_collision_layer()
onready var area_mask = get_parent().get_collision_mask()
var current = null
export onready var isDraggable: bool
var drag_offset = Vector2()

var selected = null

func _get_configuration_warning():
	if not get_parent() is CollisionObject:
		return 'Not under a collision object'
	return ''

func connectToEvents():
	var draggable = get_parent()
	isDraggable = draggable.get_parent().draggable

	if isDraggable:
		connect("dragMove", draggable, dragMoveFn)
		connect("dragStart", draggable, dragStartFn)
		connect("dragStop", draggable, dragStopFn)
		
	draggable.connect("mouse_entered", self, "mouseEntered", [draggable])
	draggable.connect("mouse_exited", self, "mouseExited", [draggable])
	draggable.connect("input_event", self, "inputEvent")
	controller.register_draggable(self)

func _ready():
	if Engine.editor_hint:
		set_process(false)
		return
	if controller == null:
		printerr('Missing DragDropController singletron!')
	else:
		connectToEvents()

func mouseEntered(node):
	selected = node

func mouseExited(node):
	selected = null

func on_hover(cast):
	emit_signal("dragMove", self, cast)

func inputEvent(camera, event, click_position, click_normal, shape_idx):
	var isLeftMouseButtonClick = event is InputEventMouseButton and event.button_index == BUTTON_LEFT
	var isTouchOnMobile = event is InputEventScreenTouch

	if isLeftMouseButtonClick or isTouchOnMobile:
		if event.is_pressed():
			if selected:
				current = selected.get_parent()
				if !isDraggable:
					PubSub.emit_signal("message",{"event":"selected", "data": current} )
				emit_signal("dragStart", self)
		elif current:
			emit_signal("dragStop", self)


func depth_sort(a,b):
	return b.get_index()<a.get_index()

