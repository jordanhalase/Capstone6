extends "res://addons/gut/test.gd"

func test_example():
	var x = 3
	var y = 4
	var z = x + y
	assert_eq(z, 6)
