extends CharacterBody2D

@onready var world = get_parent()
var dead = false

func _process(delta: float) -> void:
	look_at(get_global_mouse_position())
	
	velocity = Vector2(0, 0)
	
	if !dead:
		if Input.is_action_pressed("move_up"):
			velocity.y -= 256
		if Input.is_action_pressed("move_down"):
			velocity.y += 256
			
		if Input.is_action_pressed("move_left"):
			velocity.x -= 256
		if Input.is_action_pressed("move_right"):
			velocity.x += 256
			
	
	move_and_slide()
	
	var sucking = false
		
	for n in $Suction.get_overlapping_bodies():
		if n.has_meta("leaf"):
			sucking = true
			
			n.linear_velocity = ((self.position - n.position).normalized() * min(728 - (n.position - self.position).length(), 728)) * 0.5
			if (n.position - self.position).length() < 96:
				n.queue_free()
				world.timeLeft += 0.333
				$Crunch.play()
				
	
	if sucking:
		if !$Suck.playing:
			$Suck.play()
	else:
		$Suck.stop()


func _on_spikebox_body_entered(body: Node2D) -> void:
	if body.get_name() == "Kill":
		world.timeLeft = 0
