extends Area2D

export var playershot=true
export var angle=Vector2(0,0)
export var speed=0
var hit = false

func _ready():
	pass

func _process(delta):
	angle = angle.normalized() * speed
	position+=angle*delta
#Kills targets, misses friendlies
func _on_Bullet_body_entered(body):
	hit=true
	match playershot:
		true:
			if ("monster" in body):
				body.alive=false
			if ("isplayer" in body):
				hit=false
		false:
			if ("isplayer" in body):
				body.alive=false
			if ("monster" in body):
				hit=false
	if hit==true:
		call_deferred('free')
