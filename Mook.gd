extends KinematicBody2D

#versions
#Borrowed from Roum and also player
var GRAVITY = 2800
export var alive=true
signal died
var right=false
var left=false
var side="right"
var player

#Monster tag
export var monster=true

#Friction stuff
const FRICTION = -600
var frict
#velocity
var velocity = Vector2()
var acc=0
#Horizontal movement declares
export (int) var mookspeed = 400
var fast

func _ready():
	fast = mookspeed
	$Sprite.animation="v4idle"

func _process(delta):
	if alive==false:
		emit_signal("died")
		$Sprite.animation="v4die"
		$Sprite.scale=Vector2(1.5,1.5)
		$Col.disabled=true
		GRAVITY=0
		fast=0
	
		
		

func _physics_process(delta):
	
	
	get_input(delta)
	velocity.y += GRAVITY * delta 
	velocity.x += acc * delta 
	#applies gravity and real time
	velocity = move_and_slide(velocity, Vector2(0, -1))

func get_input(delta):		
#This code is also borrowed from Roum, directly or indirectly.
	frict = FRICTION
	
	#left = Input.is_action_pressed("left")
	#right = Input.is_action_pressed("right")
	
	acc = int(right) - int(left) #all input returns a true or false, represented numerically as a 1 or 0 respectively
	if alive==true:
		match acc:
			-1:
				$Sprite.animation="v4walk"
			#0:
				#$Sprite.animation="v4norm"
			1:
				$Sprite.animation="v4walk"
	match side:
		"left":
			$Sprite.flip_h=true
		"right":
			$Sprite.flip_h=false
	
	if (acc<0 and velocity.x >0) or(acc>0 and velocity.x <0):
		acc*=5000
	else:
		acc *= 3500
	velocity.x = clamp(velocity.x, -fast, fast)
	#Applies friction when not moving; borrowed from Roum.
	if acc == 0:
		acc = velocity.x * frict * delta

#Sees player with left or right and moves accordingly
func _on_Sight_body_entered(body):
	if (body.get_name()=="Player"):
		#right=true
		side="right"
		$Col2.disabled=true
		$Col.disabled=false
		$Sprite.scale=Vector2(1,1)
		$Sprite.position=Vector2(0,0)
		$Sprite.animation="v4yturn"
		$Sprite.flip_h=false
		body_enter(body)

func _on_Sight_body_exited(body):
	if (body.get_name()=="Player"):
		right=false
		$Sprite.animation="v4unturn"
	


func _on_LeftSight_body_entered(body):
	if (body.get_name()=="Player"):
		#left=true
		side="left"
		$Col2.disabled=true
		$Col.disabled=false
		$Sprite.scale=Vector2(1,1)
		$Sprite.position=Vector2(0,0)
		$Sprite.animation="v4yturn"
		$Sprite.flip_h=true
		body_enter(body)


func _on_LeftSight_body_exited(body):
	if (body.get_name()=="Player"):
		left=false
		$Sprite.animation="v4unturn"
		
func body_enter(body):
	player=body


func _on_Sprite_animation_finished():
	if "yturn" in $Sprite.animation:
		match side:
			"left":
				left=true
				right=false
			"right":
				right=true
				left=false
	if "unturn" in $Sprite.animation:
		$Sprite.position=Vector2(18,26)
		$Sprite.scale=Vector2(0.6,0.6)
		$Col2.disabled=false
		$Col.disabled=true
		$Sprite.animation="v4idle"
		side="right"
	if "die" in $Sprite.animation:
		call_deferred('free')
