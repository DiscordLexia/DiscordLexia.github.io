extends Area2D

var stabbing=false
var spikeout=false
var sincurve
var ex
var why
var tick=0


func _ready():
	ex=position.x
	why=position.y
	stab()
	#Makes the spikes stab with accel and decel.
func _process(delta):
	if stabbing==true:
		if spikeout==false:
			sincurve=(50*sin ((PI/20)*tick)+50)
			position=Vector2(ex+sincurve,why)
			tick+=1
			if tick==11:
				stabbing=false
				tick=0
		if spikeout==true:
			sincurve=(50*sin ((PI/20)*tick+10)+50)
			position=Vector2(ex+sincurve,why)
			tick+=1
			if tick==11:
				stabbing=false
				tick=0
#kills player
func _on_Spike_body_entered(body):
	if ("alive" in body):
		body.alive=false
	#Makes the spikes stab	
func stab():
	stabbing=true
	spikeout=false
	yield(get_tree().create_timer(0.8, true), "timeout")
	stabbing=true
	spikeout=true
	yield(get_tree().create_timer(0.8, true), "timeout")
	stab()