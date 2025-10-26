extends RigidBody2D

func _process(delta: float) -> void:
	for n in $HitArea.get_overlapping_bodies():
		if n.get_name() == "Player":
			n.get_parent().timeLeft = 0
			
	for n in $DetectionArea.get_overlapping_bodies():
		if n.get_name() == "Player":
			$Detected.visible = true
			linear_velocity = (n.position - self.position).normalized() * 200
			
			return
			
	$Detected.visible = false
