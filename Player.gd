extends KinematicBody2D

#buulets
export (PackedScene) var bullet

#player states
enum state {stat,jump,move,atk,djump}
#Borrowed from Roum
const GRAVITY = 2800

var ver=5

#If player is alive
export var alive=true
signal died

#Friction stuff
const FRICTION = -600
var frict
#velocity
var velocity = Vector2()
var acc=0
#Horizontal movement declares
export (int) var PlayerSpeed = 600
var fast
var facing="right"
#Vertical movement declares
export (int) var JumpStrength = 1400
var doublejump=0
var jump=0
var jumping=false
var djumping=false
#Triggers
var key=false
var mkey=false
signal unlock
signal standon
signal portalenter

#Adds gaps to shooting
var fired=false

#Signifies player
export var isplayer =true

func _ready():
	fast = PlayerSpeed

func _process(delta):
	if Input.is_action_just_pressed("restart"):
		alive=false
	
	if alive==false:
		emit_signal("died")

#Not gonna lie; stole this from Roum.
func _physics_process(delta):
	get_input(delta)
	velocity.y += GRAVITY * delta 
	velocity.x += acc * delta 
	#applies gravity and real time
	velocity = move_and_slide(velocity, Vector2(0, -1))
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		#print("Collided with: ", collision.collider.name)
		#detects collision with the door and unlocks it if have key
		if "Door" in collision.collider.name:
			if (key==true and (collision.collider.megadoor==false)) or (mkey==true and (collision.collider.megadoor==true)):
				var door=collision.collider
				connect('unlock', door,"_unlock")
				emit_signal('unlock')
				if door.megadoor==false:
					key=false
				else:
					mkey=false
		#detects collision with platforms and tells them to fall
		if ("Platform" in collision.collider.name and not "v2Platform" in collision.collider.name):
			var plat=collision.collider
			if collision.collider.touched==false:
				connect('standon', plat,"_on_stood")
				emit_signal('standon')
		#Detects collison with hostile monsters
		if ("monster" in collision.collider):
			alive=false


func get_input(delta):		
#This code is also borrowed from Roum, directly or indirectly.
	frict = FRICTION
	var left = Input.is_action_pressed("left")
	var right = Input.is_action_pressed("right")
	var up = Input.is_action_pressed("up")
	var shot= Input.is_action_pressed("fire")
	acc = int(right) - int(left) #all input returns a true or false, represented numerically as a 1 or 0 respectively
	match acc:
		-1:
			facing="left"
		1:
			facing="right"
			
			
	if ver==1:
		$Sprite.animation="v1"
		#Sprite.position=Vector2(949,2100)
	else:
		match acc:
			-1:
				if is_on_floor():
					$Sprite.position.x=925
					if ver==2:
						$Sprite.animation="v2walk"
					else:
						$Sprite.animation="v3walk"
			0:
				match facing:
					"left":
						$Sprite.position.x=910
					"right":
						$Sprite.position.x=950
				if is_on_floor():
					if ver==2:
						$Sprite.animation="v2idle"
					else:
						$Sprite.animation="v3idle"
			1:
				if is_on_floor():
					$Sprite.position.x=925
					if ver==2:
						$Sprite.animation="v2walk"
					else:
						$Sprite.animation="v3walk"
		
	
	if (acc<0 and velocity.x >0) or(acc>0 and velocity.x <0):
		acc*=5000
	else:
		acc *= 3500
	
	velocity.x = clamp(velocity.x, -fast, fast)
	
	
	
		
	if up and is_on_floor() and ver>=2:
		velocity.y = 0 - JumpStrength
		match facing:
			"left":
				$Sprite.position.x=960
			"right":
				$Sprite.position.x=940
		if ver>2:
			$Sprite.animation="v3jump"
		elif ver==2:
			$Sprite.animation="v2jump"
		jumping=true
		jump=1
	elif up and doublejump==0 and !is_on_floor() and jump==0 and ver>=3:
		velocity.y = 0 - (JumpStrength*0.85)
		$Sprite.animation="v3djump"
		djumping=true
		doublejump=1
		jump=1
	elif is_on_floor():
		doublejump=0
	elif !up and !is_on_floor():
		jump=0
	
	if !jumping and !djumping and !is_on_floor():
		if ver>2:
			$Sprite.animation="v3fall"
		elif ver==2:
			$Sprite.animation="v2fall"
			
	match facing:
		"left":
			$Sprite.flip_h=true
		"right":
			$Sprite.flip_h=false
		
	#Applies friction when not moving; borrowed from Roum.
	if acc == 0:
		acc = velocity.x * frict * delta
	
	
	
	if shot==true and fired==false and ver==5:
		var boolet=bullet.instance()
		boolet.position=$Sprite.global_position
		match facing:
			"left":
				boolet.angle=Vector2(-1,0)
			"right":
				boolet.angle=Vector2(1,0)
		boolet.speed=1200
		get_parent().add_child(boolet)
		fired=true
		yield(get_tree().create_timer(.4, true), "timeout")
		fired=false
	
	if !is_on_floor():
		$Sprite.scale=Vector2(0.4,0.4)
	else:
		$Sprite.scale=Vector2(0.6,0.6)


#Gets level transitions from Main
func _on_Main_v5():
	ver=5
	
func _on_Main_v4():
	ver=4
	
func _on_Main_v3():
	ver=3
	
func _on_Main_v2():
	ver=2
	
func _on_Main_v1():
	ver=1
#gets the key when over
func _key_get():
	key=true
#Detects when entering portal
func enter_portal():
	var main=get_parent()
	yield(get_tree().create_timer(.2, true), "timeout")
	main.version_tick()

func printest():
	print ("Connection established")

func _on_Sprite_animation_finished():
	if "jump" in $Sprite.animation:
		jumping=false
		djumping=false