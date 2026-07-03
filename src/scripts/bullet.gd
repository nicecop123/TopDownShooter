extends Area2D

const SPEED=200

func _process(delta: float) -> void:
	position+=transform.x*SPEED*delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage()
	queue_free()
