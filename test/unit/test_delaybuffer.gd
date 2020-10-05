extends "res://addons/gut/test.gd"

func test_delaybuffer():
	var db = DelayBuffer.new(4, 7)
	assert_eq(db.size(), 4)
	assert_eq(db.used, 4)
	assert_true(db.is_full())
	assert_false(db.is_empty())

	assert_eq(db.enqueue(1), 7)
	assert_eq(db.used, 4)
	assert_eq(db.enqueue(3), 7)
	assert_eq(db.used, 4)
	assert_eq(db.enqueue(5), 7)
	assert_eq(db.used, 4)
	assert_eq(db.enqueue(9), 7)
	assert_eq(db.used, 4)
	assert_eq(db.enqueue(11), 1)
	assert_eq(db.used, 4)
	assert_eq(db.enqueue(13), 3)
	assert_eq(db.used, 4)
	assert_eq(db.enqueue(15), 5)
	assert_eq(db.used, 4)
	assert_eq(db.enqueue(17), 9)
	assert_eq(db.used, 4)

	assert_eq(db.dequeue(), 11)
	assert_eq(db.used, 3)
	assert_eq(db.dequeue(), 13)
	assert_eq(db.used, 2)
	assert_eq(db.dequeue(), 15)
	assert_eq(db.used, 1)
	assert_eq(db.dequeue(), 17)
	assert_eq(db.used, 0)
	assert_true(db.is_empty())
	assert_false(db.is_full())

func test_chain():
	var db = []
	db.resize(4)
	for i in range(4):
		db[i] = DelayBuffer.new(4, 0)
	var lp = 1
	lp = db[0].enqueue(lp)
	assert_eq(lp, 0)
	lp = db[1].enqueue(lp)
	assert_eq(lp, 0)
	lp = db[2].enqueue(lp)
	assert_eq(lp, 0)
	lp = db[3].enqueue(lp)
	assert_eq(lp, 0)
