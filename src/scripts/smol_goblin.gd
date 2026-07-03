extends CharacterBody2D

var health=3
@onready var player=get_node("/root/MainLevel/Player")
const EXP_ORB = preload("res://src/scenes/exp_orb.tscn")

func _ready() -> void:
	pass

func _physics_process(_delta: float) -> void:
	var direction=global_position.direction_to(player.global_position)
	velocity=35*direction
	move_and_slide()

func take_damage():
	health-=1
	#$Slime.play_hurt()
	
	if health==0:
		die()
	
		#const SMOKE_SCENE= preload("res://smoke_explosion/smoke_explosion.tscn")
		#var smoke= SMOKE_SCENE.instantiate()
		#get_parent().add_child(smoke)
		#smoke.global_position=global_position

func die():
	var exporb=EXP_ORB.instantiate()
	exporb.global_position=global_position
	get_parent().call_deferred("add_child",exporb)
	queue_free()
