extends StaticBody2D
var crumb=false
export var drop=false
export var touched=false
export var ver=3


func _ready():
	if ver==3:
		$Sprite.animation="v3norm"
	elif ver==4:
		$Sprite.animation="v4norm"

#Crumbles platforms that do crumble
func _on_stood():
	touched=true
	if drop==true:
		yield(get_tree().create_timer(.5, true), "timeout")
		if crumb==false:
			if ver==3:
				$Sprite.animation="v3crumble"
			if ver==4:
				$Sprite.animation="v4crumble"
			print("Platform Crumbling")
			crumb=true
		yield(get_tree().create_timer(.5, true), "timeout")
		call_deferred('free')