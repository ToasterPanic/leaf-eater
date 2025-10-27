extends CharacterBody2D

var goingUp = false
var lastTouch = 0
@onready var mainX = global_position.x

func _ready() -> void:
	var color = randi_range(1, 5)
	
	if color == 2:
		$Blue.visible = true
	elif color == 3:
		$Green.visible = true
	elif color == 4:
		$Magenta.visible = true
	elif color == 5:
		$Yellow.visible = true

func _process(delta) -> void:
	global_position.x = mainX
	velocity.x = 0
	if goingUp:
		velocity.y = -440
	else:
		velocity.y = 440
	
	move_and_slide()
	
	lastTouch += delta
	
	for n in $Hitbox.get_overlapping_bodies():
		if n.get_name() == "Tiles":
			if lastTouch > .25:
				lastTouch = 0
				goingUp = !goingUp
		if n.get_name() == "Player":
			n.get_parent().timeLeft = 0
