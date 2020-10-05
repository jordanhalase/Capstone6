extends Area2D

# This node essentially acts like a struct and is fully controlled from its
# parent.

var delayBuffer = null
var next = null

# TODO (Jordan): When a cat collides, then iterate through the remaining
# birds via their `next` references, disable rendering, and spawn a
# `BirdUnchained`, preferrably from an object pool.
#
# Then pass the current position, velocity, and animation state to that
# `BirdUnchained`.
func _on_BirdFollowing_body_entered(body):
	pass # Replace with function body.
