extends RigidBody2D


func _ready():
	var color = randi_range(1, 3)
	
	$Red.visible = color == 1
	$Orange.visible = color == 2
	$Yellow.visible = color == 3
