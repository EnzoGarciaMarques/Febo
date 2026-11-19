extends Node2D

var cardDragged
var isHover: bool

func _process(delta: float) -> void:
	if cardDragged:
		var mousePos = get_global_mouse_position()
		cardDragged.position = mousePos

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		var card = raycast_cards()
		if event.is_pressed():
			if card:
				cardDragged = card
		else:
			if card:
				card.global_position = Vector2(100, 100)
			else:
				card = null
			cardDragged = null

func raycast_cards():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = 1
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0].collider.get_parent()
	return null
	
func connectCard(card):
	card.connect("hovered", onHover)
	card.connect("hoveredOff", offHover)
	
func onHover(card):
	if !isHover:
		isHover = true
		hoverEffect(card, true)

func offHover(card):
	isHover = false
	hoverEffect(card, false)
	
func hoverEffect(card, hovered):
	if hovered:
		card.scale = Vector2(1.05, 1.05)
		card.z_index = 2
	else:
		card.scale = Vector2(1, 1)
		card.z_index = 1
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
