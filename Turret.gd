extends KinematicBody2D

#versions
export (PackedScene) var bullet
export var alive=true
signal died
var player
var angle
var tick=0

#Monster tag
export var monster=true


func _ready():
	_on_Guntimer_timeout()

func _process(delta):
	tick+=1
	
	if alive==false:
		emit_signal("died")
		$Col.disabled=true
		$Sprite.animation="v4die"
		$Sprite.scale=Vector2(1.5,1.5)
		$Guntimer.stop()
	
		

#Aims and fires boolets
#THIS TOOK ME LITERALLY HOURS TO GET WORKING BECAUSE IT DIDN'T
#WANT TO LOAD THE FRIKKIN BULLET OMG!!
func _on_Guntimer_timeout():
	print("fire")
	var bulet=bullet.instance()
	bulet.playershot=false
	bulet.position=$Gun.global_position
	bulet.angle=Vector2(-1,0)
	bulet.speed=1200
	get_parent().get_parent().add_child(bulet)

func _on_Sprite_animation_finished():
	
	if "die" in $Sprite.animation:
		call_deferred('free')