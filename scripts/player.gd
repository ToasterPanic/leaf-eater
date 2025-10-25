extends CharacterBody2D

func _process(delta: float) -> void:
	look_at(get_global_mouse_position())
	
	velocity = Vector2(0, 0)
	
	if Input.is_action_pressed("move_up"):
		velocity.y -= 256
	if Input.is_action_pressed("move_down"):
		velocity.y += 256
		
	if Input.is_action_pressed("move_left"):
		velocity.x -= 256
	if Input.is_action_pressed("move_right"):
		velocity.x += 256
		
	for n in $Suction.get_overlapping_bodies():
		if n.has_meta("leaf"):
			n.linear_velocity = (self.position - n.position).normalized() * min(512 - (n.position - self.position).length(), 512)
			if (n.position - self.position).length() < 76:
				n.queue_free()
	
	move_and_slide()
