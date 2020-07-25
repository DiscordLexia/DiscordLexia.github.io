extends Node2D
#development stage/level
var version="v0.5"
#all things to load in
export (PackedScene) var v1map
export (PackedScene) var v2map
export (PackedScene) var v3map
export (PackedScene) var v4map
export (PackedScene) var v5map
#stage signals
signal v5
signal v4
signal v3
signal v2
signal v1
var started=false
#Map removal
signal nomap


func _ready():
	emit_signal("v5")
	load_map(5)
	
	
func _process(delta):
	
	if (Input.is_action_just_pressed("devcheat")):
		version_tick()
				
func load_map(mapno):
	emit_signal("nomap")
	var map
	match mapno:
		1:
			map = v1map.instance()
		2:
			map = v2map.instance()
		3:
			map = v3map.instance()
		4:
			map = v4map.instance()
		5:
			map = v5map.instance()
		
	$Mainmap.add_child(map)
	connect("nomap", map,"on_unload")
	
#Ends game on player death
func _on_Player_died():
	$Menu/Menucam.current=true
	$Menu/Diedbutton.show()
	$Menu/Diedlabel.show()

#Restarts the game
func _on_Diedbutton_pressed():
	get_tree().reload_current_scene()


#func _on_Player_portalenter():
	#version_tick()
	
func version_tick():
	match version:
		"v0.5":
			print ("Version 0.4")
			version="v0.4"
			emit_signal("v4")
			$Player.position=Vector2(0,0)
			load_map(4)
		"v0.4":
			print ("Version 0.3")
			version="v0.3"
			emit_signal("v3")
			$Player.position=Vector2(0,0)
			load_map(3)
		"v0.3":
			print ("Version 0.2")
			version="v0.2"
			emit_signal("v2")
			$Player.position=Vector2(0,0)
			load_map(2)
		"v0.2":
			print ("Version 0.1")
			version="v0.1"
			emit_signal("v1")
			$Player.position=Vector2(0,0)
			load_map(1)
		"v0.1":
			print ("Version 0.1")


func _on_Startbutton_pressed():
	$Menu/Startbutton.hide()
	$Menu/Title.hide()
	$Menu/Instructions.hide()
	$Player/Col.disabled=false
	$Player/Cam.current=true
	$Player.position=Vector2(0,0)
	yield(get_tree().create_timer(.3, true), "timeout")
	started=true
