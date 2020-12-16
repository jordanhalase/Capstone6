extends KinematicBody2D

class_name Player

const UP := Vector2(0, -1)
const GRAVITY: float = 4.0
const MAX_HSPEED: float = 80.0
const MAX_VSPEED: float = 168.0
const JUMP_HEIGHT: float = 164.0
const ACCELERATION: float = 6.0
const FRICTION_COEF: float = 0.16
const FRICTION: float = ACCELERATION*FRICTION_COEF

const WEAPON := preload("res://Nodes/Weapon_In_Motion.tscn")
const CAT := preload("res://Nodes/Cat.tscn")
const dyingPlayer := preload("res://Nodes/DyingPlayer.tscn")
const BirdUnchainedScene := preload("res://Nodes/BirdUnchained.tscn")

var velocity: Vector2 = Vector2()
onready var map: CyclicMap = get_parent()
onready var init_pos = position

var hasThrowable: bool = false

func _ready():
	pass

func _physics_process(_delta: float) -> void:
	
	# Integrate gravity using forward Euler method
	velocity.y = min(MAX_VSPEED, velocity.y + GRAVITY)
	
	if Input.is_action_pressed("ui_right"):
		# player moving right
		$AnimatedSprite.set_flip_h(false)
		velocity.x = min(velocity.x + ACCELERATION, MAX_HSPEED)
		
	elif Input.is_action_pressed("ui_left"):
		# player moving left
		$AnimatedSprite.set_flip_h(true)
		velocity.x = max(velocity.x - ACCELERATION, -MAX_HSPEED)
	
	# Check if the player is on the floor
	if is_on_floor():
		# velocity.y = 0
		if Input.is_action_pressed("ui_up"):
			# player jumping
			velocity.y = -JUMP_HEIGHT
			$AnimatedSprite.play("fly");
			#player shooting
			if hasThrowable:
				var weapon = WEAPON.instance()
				get_parent().add_child(weapon)
				#chooses which side to shoot from
				if $AnimatedSprite.flip_h == false:
					weapon.position = $ShootRight.global_position
				else:
					weapon.position = $ShootLeft.global_position
					weapon.direction = -1
			hasThrowable = false
		else:
			if velocity.x == 0: $AnimatedSprite.play("idle")
			else: $AnimatedSprite.play("walk");
		if velocity.x >= 0:
			velocity.x = max(0, velocity.x - FRICTION)
		else:
			velocity.x = min(0, velocity.x + FRICTION)
			
	velocity = move_and_slide(velocity, UP)

# This was commented here because the score is counted multiple
# times due to the follwingBirds!
#	for i in get_slide_count():
#		var collision = get_slide_collision(i)
#		if collision.collider.name == "BirdUnchained":
#			# TODO: figure out how to add the little bird back to the chain
#			collision.collider.queue_free()
			
	# warning-ignore:return_value_discarded
	map.level_wrap(self)

# lets pick up nut node know if the player already has a nut
func pick_up() -> bool:
	if hasThrowable == false:
		hasThrowable = true
		return true
	else:
		return false

func killPlayer() -> void:
	var die = dyingPlayer.instance()
	die.position = position
	get_parent().add_child(die)
	hide()
	get_tree().paused = true
	die.play()
	yield(die, "animation_finished")
	position = init_pos
	show()
	map.startDoor()


func _on_Area2D_body_entered(body):
	if body is Cat: 
		EventBus.emit_signal("cat_catch")
		unchainBirds()
		resetCats()
		killPlayer()
		
func resetCats() -> void:
	var cats = get_tree().get_nodes_in_group("Cat")
	for cat in cats:
		var spawn = cat.spawnNode
		cat.queue_free()
		spawn._reset_Timer()

func unchainBirds() -> void:
	var birds = get_tree().get_nodes_in_group("FollowingBirds")
	for bird in birds:
		if bird.active:
			var birdUnchained := BirdUnchainedScene.instance()
			map.call_deferred("add_child", birdUnchained)
			birdUnchained.set_global_position(bird.position)
			bird.set_active(false)
			EventBus.emit_signal("bird_dropped")

func _on_AnimatedSprite_animation_finished():
	pass
