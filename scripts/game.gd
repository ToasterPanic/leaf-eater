extends Node2D

var timeLeft = 10
var lastRounder = 9

var clock = 60 * 3

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
		print($LifeSpeeding.playing)
		if not $LifeSpeeding.playing:
			$LifeSpeeding.play()
		timeLeft -= delta
		clock -= delta
		
		$CanvasLayer/Control/Title.visible = false
		$CanvasLayer/Control/HUD.visible = true
		
		$CanvasLayer/Control/HUD/Timer.text = str(floori(clock) / 60) + ":" + str(floori(clock) % 60)
	
	if timeLeft > 10:
		timeLeft = 10

	
	if player.dead:
		print(timeLeft)
		$CanvasLayer/Control/HUD/FinalCountdown.modulate.a /= 1.03
		$LifeSpeeding.pitch_scale *= 1 - (0.15 * delta)
		$LifeSpeeding.volume_db -= 7 * delta
		if timeLeft < -3:
			get_tree().reload_current_scene()
		return
		
		
		
	
	if lastRounder != ceili(timeLeft):
		lastRounder = ceili(timeLeft)
		AudioServer.set_bus_effect_enabled(1, 0, false)
		if lastRounder <= 5:
			AudioServer.set_bus_effect_enabled(1, 0, true)
			$Heartbeat.play()
			$CanvasLayer/Control/HUD/FinalCountdown.text = str(lastRounder)
			$CanvasLayer/Control/HUD/FinalCountdown.modulate.a = 1
		
	if timeLeft <= 0:
		$CanvasLayer/Control/HUD/FinalCountdown.text = "TRY AGAIN."
		$CanvasLayer/Control/HUD/FinalCountdown.modulate.a = 3
		
		player.get_node("Particles").restart()
		player.get_node("CollisionShape2D").queue_free()
		player.get_node("Sprite").queue_free()
		$Player/Explode.play()
		$Player/Suction/Shape.queue_free()
		player.dead = true
	
	$CanvasLayer/Control/HUD/ProgressBar.value = timeLeft
	$CanvasLayer/Control/HUD/FinalCountdown.modulate.a /= 1.1
