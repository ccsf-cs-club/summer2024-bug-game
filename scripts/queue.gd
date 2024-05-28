# Cuz Godot is stupid and doesn't have a queue structure
extends RefCounted
class_name Queue

var _queue := []

func enqueue(item):
	_queue.append(item)

func dequeue():
	if not is_empty():
		return _queue.pop_front()
	else:
		return null

func peek():
	if not is_empty():
		return _queue[0]
	else:
		return null

func is_empty():
	return _queue.size() == 0

func size():
	return _queue.size()
