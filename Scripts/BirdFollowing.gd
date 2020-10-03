extends Area2D

const DELAY_FRAMES = 10

var delayBuffer = null
var next = null

#func _init(bufferLength: int, initial).():
#	delayBuffer = DelayBuffer.new(bufferLength, initial)

func _ready():
	#delayBuffer = DelayBuffer.new(DELAY_FRAMES, position)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	if next != null:
#		next.set_global_position(delayBuffer.enqueue(position))
