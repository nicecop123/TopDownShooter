extends CharacterBody2D
signal health_depleted

var health=100.0
var runspeed=120
var walkspeed=40


func _physics_process(_delta: float) -> void:
	var direction=Input.get_vector("move_left","move_right","move_up","move_down")
	velocity=direction*runspeed
	move_and_slide()
	
	if velocity.length()>0:
		$AnimatedSprite2D.play("Run")
	else:
		$AnimatedSprite2D.play("Idle")
	
	if direction.x < 0:
		$AnimatedSprite2D.flip_h = true
	elif direction.x > 0:
		$AnimatedSprite2D.flip_h = false
	
	const DAMAGE_RATE=1.0
	var overlapping_mobs=$HurtBox.get_overlapping_bodies()
	if overlapping_mobs.size()>0:
		health-=DAMAGE_RATE*overlapping_mobs.size()
		$HealthBar.value=health
		if health <=0.0:
			health_depleted.emit()


func _on_pickup_range_area_entered(area: Area2D) -> void:
	if area.has_method("attract_to"):
		area.attract_to(self)
