extends Area2D

export var ver=3

func _ready():
	match ver:
		3:
			$Sprite.animation="v3"
#kills player
func _on_Lava_body_entered(body):
	if ("alive" in body):
		print ("Working")
		body.alive=false