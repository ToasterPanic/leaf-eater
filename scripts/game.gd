extends Node2D

var timeLeft = 10
var lastRounder = 9

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
	if !$SpawnZone.has_overlapping_bodies():
		timeLeft -= delta
	
	if timeLeft > 10:
		timeLeft = 10

	
	if player.dead:
		print(timeLeft)
		if timeLeft < -1:
			get_tree().reload_current_scene()
		return
	
	if lastRounder != ceili(timeLeft):
		lastRounder = ceili(timeLeft)
		if lastRounder <= 5:
			$Heartbeat.play()
			$CanvasLayer/Control/FinalCountdown.text = str(lastRounder)
			$CanvasLayer/Control/FinalCountdown.modulate.a = 1
		
	if timeLeft <= 0:
		$CanvasLayer/Control/FinalCountdown.text = "TRY AGAIN."
		$CanvasLayer/Control/FinalCountdown.modulate.a = 3
		
		player.get_node("Particles").restart()
		player.get_node("CollisionShape2D").queue_free()
		player.dead = true
	
	$CanvasLayer/Control/ProgressBar.value = timeLeft
	$CanvasLayer/Control/FinalCountdown.modulate.a /= 1.1
