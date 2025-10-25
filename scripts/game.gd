extends Node2D

var timeLeft = 10

var scenes = {
	"leaf": preload("res://scenes/leaf.tscn")
}

@onready var player = $Player

func _ready():
	for n in $Spawns.get_children():
		var scene = scenes[n.get_meta("type")]
		
		var i = 0
		while i < n.get_meta("amount"):
			var node = scene.instantiate()
			node.position = n.position 
			node.linear_velocity = Vector2(randi_range(-256, 256), randi_range(-256, 256))
			add_child(node)
			
			i += 1

func _process(delta: float) -> void:
	timeLeft -= delta
	
	if timeLeft > 10:
		timeLeft = 10
		
	if timeLeft <= 0:
		
	
	$CanvasLayer/Control/ProgressBar.value = timeLeft
