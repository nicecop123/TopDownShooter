extends Node2D

const Bullet = preload("res://scenes/bullet.tscn")
@onready var muzzle=$WeaponPivot/Muzzle

func _process(delta: float) -> void:
	look_at(get_global_mouse_position())
	
	rotation_degrees=wrap(rotation_degrees,0,360)
	
	if rotation_degrees>90 and rotation_degrees<270:
		scale.y=	-1
	else:
		scale.y=1

	if Input.is_action_just_pressed("shoot"):
		var bullet=Bullet.instantiate()
		bullet.global_position=muzzle.global_position
		bullet.rotation=global_rotation
		get_tree().root.add_child(bullet)
