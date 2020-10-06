extends Area2D

# This node essentially acts like a struct and is fully controlled from its
# parent.

const BirdUnchained := preload("res://Nodes/BirdUnchained.tscn")

var delayBuffer: DelayBuffer
var next: Node
var active: bool
var map: Node

func _ready():
	# TODO: Only set to active when birds are collected
	set_active(false)

func set_active(active: bool) -> void:
	self.active = active
	$Sprite.visible = active

# TODO (Jordan): When a cat collides, then iterate through the remaining
# birds via their `next` references, disable rendering, and spawn a
# `BirdUnchained`, preferrably from an object pool.
#
# Then pass the current position, velocity, and animation state to that
# `BirdUnchained`.
func _on_BirdFollowing_body_entered(body):
	var bird = self
	while bird != null:
		if (bird.active):
			var birdUnchained := BirdUnchained.instance()
			map.add_child(birdUnchained)
			birdUnchained.set_global_position(bird.position)
			bird.set_active(false)
		bird = bird.next

