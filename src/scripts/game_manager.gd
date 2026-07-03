extends Node

signal xp_changed(current_xp:float,xp_needed:float)
signal leveled_up(current_level:int)

var current_level: int=0
var current_xp: float=0.0
var xp_needed: float=100.0

func gain_xp(amount:float):
	current_xp+=amount
	
	while current_xp>xp_needed:
		current_xp-=xp_needed
		level_up()
		
	xp_changed.emit(current_xp, xp_needed)

func level_up():
	current_level+=1
	xp_needed=round(xp_needed*1.5)
	leveled_up.emit(current_level)
