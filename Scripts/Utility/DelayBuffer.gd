class_name DelayBuffer

var array: Array = []
var front: int = 0
var back: int = 0
var used: int = 0

func _init(size: int, initial) -> void:
	array.resize(size)
	for i in range(size):
		array[i] = initial
	used = size

func size() -> int:
	return array.size()
	
func is_full() -> bool:
	return used == array.size()

func is_empty() -> bool:
	return used == 0

func enqueue(element):
	var popped = array[front]
	if is_full():
		front = (front + 1) % array.size()
	else:
		used += 1
	array[back] = element
	back = (back + 1) % array.size()
	return popped

func dequeue():
	if is_empty():
		push_error("Cannot dequeue empty buffer")
	var popped = array[front]
	front = (front + 1) % array.size()
	used -= 1
	return popped
