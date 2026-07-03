extends Area2D

@export var xp_value: float = 10.0
var speed: float = 0.0
var max_speed: float = 200.0
var target: Node2D = null

func _physics_process(delta: float) -> void:
	if target:
		speed = move_toward(speed, max_speed, 400 * delta)
		var direction = global_position.direction_to(target.global_position)
		global_position += direction * speed * delta

func attract_to(player_node: Node2D) -> void:
	target = player_node

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		GameManager.gain_xp(xp_value)
		queue_free() 
