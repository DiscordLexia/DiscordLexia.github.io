extends Area2D

export var portalversion=2
var once=false

func _ready():#version picker
	$Col.disabled=true
	if portalversion==2:
		$Sprite.animation="v2"
	elif portalversion==3:
		$Sprite.animation="v3"
	elif portalversion==4:
		$Sprite.animation="v4"
		#Prevents major glitch
	yield(get_tree().create_timer(.5, true), "timeout")
	$Col.disabled=false

func _on_Portal_body_entered(body):
	if (body.get_name()=="Player" and once==false):
		once=true
		print ("portal entered")
		body.enter_portal()
		call_deferred('free')
		
		