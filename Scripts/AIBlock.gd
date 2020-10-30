extends Area2D

export var facesRight: bool = true

export var jumpAbove: bool = true
export var jumpAcross: bool = true
export var jumpBelow: bool = true

export var jumpAboveVel: float = 156
export var jumpAcrossVel: float = 80
export var jumpBelowVel: float = 20

func _on_Area2D_body_entered(body) -> void:
	body._decide(self)
