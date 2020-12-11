extends Area2D

class_name BirdFollowing

# This node essentially acts like a struct and is fully controlled from its
# parent.

const BirdUnchainedScene := preload("res://Nodes/BirdUnchained.tscn")

var delayBuffer: DelayBuffer
var next: BirdFollowing
var active: bool
var map: TileMap

func _ready() -> void:
	# TODO: Only set to active when birds are collected
	set_active(false)

func set_active(activate: bool) -> void:
	active = activate
	$Sprite.visible = activate

# TODO (Jordan): When a cat collides, then iterate through the remaining
# birds via their `next` references, disable rendering, and spawn a
# `BirdUnchained`, preferrably from an object pool.
#
# Then pass the current position, velocity, and animation state to that
# `BirdUnchained`.
func _on_BirdFollowing_body_entered(_body: KinematicBody2D) -> void:
	var bird: BirdFollowing = self
	while bird != null:
		if (bird.active):
			var birdUnchained := BirdUnchainedScene.instance()
			map.call_deferred("add_child", birdUnchained)
			birdUnchained.set_global_position(bird.position)
			bird.set_active(false)
			EventBus.emit_signal("bird_dropped")
		bird = bird.next

