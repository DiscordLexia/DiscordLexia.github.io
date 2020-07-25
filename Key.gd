extends Area2D

#collect key
signal key
export var keyversion=2

# Called when the node enters the scene tree for the first time.
func _ready():
	#Changes sprite according to version
	if keyversion==2:
		$Sprite.animation="v2"
	elif keyversion==3:
		$Sprite.animation="v3"
	elif keyversion==4:
		$Sprite.animation="v4"

func _on_Key_body_entered(body):
	if (body.get_name()=="Player"):
		connect('key', body,"_key_get")
		emit_signal("key")
		call_deferred('free')
