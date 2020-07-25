extends StaticBody2D

var unlocked=0
var open=0
var tick=0
var ex=0
var why=0
#Variables and stuff
export var doorversion=2
export var megadoor=false
var megamult=1


func _ready():
	#Changes sprite according to version
	if doorversion==2:
		$Sprite.animation="v2"
	elif doorversion==3:
		$Sprite.animation="v3"
	elif doorversion==4:
		$Sprite.animation="v4"
		
	if megadoor==true:
		megamult=4


func _process(delta):
	#opens door
	if unlocked==1:
		open=((120*megamult)*sin ((PI/60)*tick+30)+(120*megamult))
		position=Vector2(ex,why-open)
		tick+=1
		if tick==61:
			unlocked=2
		
		#Unlocks door to open when touched with key
func _unlock():
	if unlocked==0:
		print ("Door Unlocked")
		ex=position.x
		why=position.y
		unlocked=1
		yield(get_tree().create_timer(.1, true), "timeout")
		
