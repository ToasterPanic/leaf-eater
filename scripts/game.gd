extends Node2D

var timeLeft = 10
var lastRounder = 9

var clock = (60 * 2.5) + 10

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
			
	$CanvasLayer/Control/Title/Settings/VFlowContainer/MasterVolume.value = global.master_volume
	$CanvasLayer/Control/Title/Settings/VFlowContainer/MusicVolume.value = global.music_volume
	$CanvasLayer/Control/Title/Settings/VFlowContainer/SoundEffectVolume.value = global.sfx_volume

func _process(delta: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), (100 - global.master_volume) / -4.5)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), (100 - global.music_volume) / -4.5)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), (100 - global.sfx_volume) / -4.5)
	
	if !$SpawnZone.has_overlapping_bodies():
		if not $LifeSpeeding.playing:
			$LifeSpeeding.play()
			
		if player.win:
			$CanvasLayer/Control/Title.visible = true
			$CanvasLayer/Control/HUD.visible = false
			$CanvasLayer/Control/Title/TitleContainer/Title.text = "YOU WIN"
			$CanvasLayer/Control/Title/TitleContainer/Subtitle.text = "THANK YOU FOR PLAYING"
		else:
			timeLeft -= delta
			clock -= delta
			
			$CanvasLayer/Control/Title.visible = false
			$CanvasLayer/Control/HUD.visible = true
			
			$CanvasLayer/Control/HUD/Timer.text = str(floori(clock) / 60) + ":" + str(floori(clock) % 60)
	
	if timeLeft > 10:
		timeLeft = 10

	
	if player.dead:
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


func _on_win_zone_body_entered(body: Node2D) -> void:
	if body.get_name() == "Player":
		player.win = true

func set_panel(panel: String) -> void:
	for n in $CanvasLayer/Control/Title.get_children():
		if n.is_class("Panel"):
			n.visible = n.get_name() == panel

func _on_close_panel_button_pressed() -> void:
	set_panel("POOOGSMDIJDJGKMMV NM,x.,//////,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,")


func _on_credits_pressed() -> void:
	set_panel("Credits")


func _on_settings_pressed() -> void:
	set_panel("Settings")


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_master_volume_value_changed(value: float) -> void:
	global.master_volume = value


func _on_music_volume_value_changed(value: float) -> void:
	global.music_volume = value


func _on_sound_effect_volume_value_changed(value: float) -> void:
	global.sfx_volume = value
