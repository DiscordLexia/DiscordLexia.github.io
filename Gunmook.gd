extends KinematicBody2D

#versions
export (PackedScene) var bullet
export var alive=true
signal died
var player
var angle=0
var tick=0

#Monster tag
export var monster=true
var mane
var started=false

func _ready():
	mane=get_parent().get_parent().get_parent()
func _process(delta):
	if mane.started==true:
		if started==false:
			$Guntimer.start()
			started=true
	
	if alive==true:
		angle=(0.4*sin ((PI/120)*tick))
		$Gun.rotation=-angle
		
		
	
	
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
	#angle=(0.4*sin ((PI/120)*tick))
	bulet.playershot=false
	bulet.position=$Gun/Barrel.global_position
	bulet.angle=Vector2(-1,angle)
	#bulet.angle=Vector2(-1,0)
	bulet.speed=700
	get_parent().get_parent().add_child(bulet)

func _on_Sprite_animation_finished():
	
	if "die" in $Sprite.animation:
		call_deferred('free')
