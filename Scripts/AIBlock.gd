extends Area2D

class_name AIBlock

export var facesRight: bool = true

export var jumpAbove: bool = true
export var jumpAcross: bool = true
export var jumpBelow: bool = true

export var jumpAboveVel: float = 156
export var jumpAcrossVel: float = 80
export var jumpBelowVel: float = 20

func _on_Area2D_body_entered(body: KinematicBody2D) -> void:
	# Godot weirdness: Cannot preload Cat.gd here
	body._decide(self)
