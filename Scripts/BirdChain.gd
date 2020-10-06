extends Node

const BirdFollowing = preload("res://Nodes/BirdFollowing.tscn")

onready var target: Node = get_node("../Player")
var num_birds: int = 0
var delayBuffer: DelayBuffer
var next: Node

# The size of the delay buffer
const DELAY_FRAMES = 12

# This is used to keep distance to the first bird while keeping the rest
# of the birds tightly packed
const DELAY_TARGET = 4

func _init(num_birds: int) -> void:
	self.num_birds = num_birds

func _ready() -> void:
	delayBuffer = DelayBuffer.new(DELAY_FRAMES + DELAY_TARGET, target.position)
	
	var lag: Node
	if (num_birds > 0):
		lag = BirdFollowing.instance()
		add_child(lag)
		lag.delayBuffer = DelayBuffer.new(DELAY_FRAMES, target.position)
		lag.set_global_position(target.position)
		next = lag
	
	var bird: Node
	for i in range(num_birds - 1):
		bird = BirdFollowing.instance()
		add_child(bird)
		bird.delayBuffer = DelayBuffer.new(DELAY_FRAMES, target.position)
		bird.set_global_position(target.position)
		lag.next = bird
		lag = bird

func _process(_delta):
	# TODO: This will eventually need to pass velocity and animation state
	# in addition to position.
	var lag: Node = self
	var lagpos = target.position
	var bird: Node = next
	while bird != null:
		lagpos = lag.delayBuffer.enqueue(lagpos)
		bird.set_global_position(lagpos)
		lag = bird
		bird = bird.next

func increment_chain() -> void:
	var bird = next
	while bird != null:
		if bird.active:
			bird = bird.next
		else:
			bird.set_active(true)
			return
	print("Bird chain overflow")
