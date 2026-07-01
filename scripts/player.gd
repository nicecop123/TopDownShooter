extends CharacterBody2D
signal health_depleted

var health=100.0

func _physics_process(_delta: float) -> void:
	var direction=Input.get_vector("move_left","move_right","move_up","move_down")
	velocity=direction*600
	move_and_slide()
	
	if velocity.length()>0:
		$HappyBoo.play_walk_animation()
	else:
		$HappyBoo.play_idle_animation()
	
	rotation_degrees=wrap(rotation_degrees,0,360)
	
	if rotation_degrees>90 and rotation_degrees<270:
		scale.x=	-1
	else:
		scale.x=1
	
	const DAMAGE_RATE=1.0
	var overlapping_mobs=$HurtBox.get_overlapping_bodies()
	if overlapping_mobs.size()>0:
		health-=DAMAGE_RATE*overlapping_mobs.size()
		$HealthBar.value=health
		if health <=0.0:
			health_depleted.emit()
