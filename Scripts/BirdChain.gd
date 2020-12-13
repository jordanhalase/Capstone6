extends Node

const BirdFollowingScene = preload("res://Nodes/BirdFollowing.tscn")

onready var target: Node = get_node("../Player")
var map: TileMap
var num_birds: int = 0
var delayBuffer: DelayBuffer
var next: BirdFollowing


# The size of the delay buffer
const DELAY_FRAMES: int = 12

# This is used to keep distance to the first bird while keeping the rest
# of the birds tightly packed
const DELAY_TARGET: int = 4

func _init(birds: int) -> void:
	num_birds = birds

func _ready() -> void:
	map = get_parent()
	delayBuffer = DelayBuffer.new(DELAY_FRAMES + DELAY_TARGET, target.position)
	# warning-ignore:return_value_discarded
	#EventBus.connect("bird_collected", self, "increment_chain")
	
	var lag: BirdFollowing
	if (num_birds > 0):
		lag = BirdFollowingScene.instance()
		add_child(lag)
		lag.delayBuffer = DelayBuffer.new(DELAY_FRAMES, target.position)
		lag.map = map
		lag.set_global_position(target.position)
		next = lag
	
	var bird: BirdFollowing
	for _i in range(num_birds - 1):
		bird = BirdFollowingScene.instance()
		add_child(bird)
		bird.delayBuffer = DelayBuffer.new(DELAY_FRAMES, target.position)
		bird.map = map
		bird.set_global_position(target.position)
		lag.next = bird
		lag = bird

func _process(_delta: float) -> void:
	# TODO: This will eventually need to pass velocity and animation state
	# in addition to position.
	var lag: Node = self
	var lagpos: Vector2 = target.position
	var bird: BirdFollowing = next
	while bird != null:
		lagpos = lag.delayBuffer.enqueue(lagpos)
		bird.set_global_position(lagpos)
		lag = bird
		bird = bird.next

func increment_chain() -> void:
	var bird: BirdFollowing = next
	while bird != null:
		if bird.active:
			bird = bird.next
		else:
			bird.set_active(true)
			return
	push_error("Bird chain overflow")

func getCount() -> int:
	for bir in BirdFollowing:
		print("hah")
	return 4
