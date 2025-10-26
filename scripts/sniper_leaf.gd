extends Sprite2D

var timeUntilShot = 1

var randomized = randi_range(0, 360)

func _ready() -> void:
	$Indicator.rotation_degrees = randomized

func _process(delta: float) -> void:
	$Line.visible = false
	$Line2.visible = false
			
	for n in $Area.get_overlapping_bodies():
		if n.get_name() == "Player":
			if not $ChargeFire.playing:
				$ChargeFire.play()
			
			timeUntilShot -= delta * 0.333
			look_at(n.position)
			
			rotation_degrees -= 180
			
			$Indicator.rotation_degrees = -rotation_degrees + randomized
			
			$Line.visible = true
			$Line2.visible = true
			
			$Line.points[0].x = -(n.position - position).length() * 4
			$Line2.points = $Line.points
			$Line.width = (1 - timeUntilShot) * 32
			
			if timeUntilShot <= 0:
				n.get_parent().timeLeft = 0
			
			return
			
			
	$ChargeFire.stop()
	timeUntilShot = 1
