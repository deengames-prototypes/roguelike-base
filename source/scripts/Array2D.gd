class_name Array2D
extends Node
 
var width = 0
var height = 0
var _data = [] # Simplest is best. One-dimensional array of length w * h
 
func _init(cells_wide, cells_high):
	self._data = []
	self.width = cells_wide
	self.height = cells_high
 
	# Initialize array with nulls
	for _i in range(self.width * self.height):
		self._data.append(null)
 
func to_dict():
	return {
		"width": self.width,
		"height": self.height,
		"data": self._data
	}
 
func load_from(dict):
	self.width = dict["width"]
	self.height = dict["height"]
	self._data = dict["data"]
 
func has(x, y):
	if x < 0 or x >= self.width or y < 0 or y >= self.height:
		pass #("Invalid coordinates: %s, %s" % [x, y])
		return false
	else:
		var index = self._get_index(x, y)
		return self._data[index] != null
 
func get_at(x, y):
	if x < 0 or x >= self.width or y < 0 or y >= self.height:
		pass #("Invalid coordinates: %s, %s" % [x, y])
		return null
	else:
		var index = self._get_index(x, y)
		return self._data[index]
 
func set_at(x, y, item):
	if x < 0 or x >= self.width or y < 0 or y >= self.height:
		pass #("Invalid coordinates: %s, %s" % [x, y])
	else:
		var index = self._get_index(x, y)
		self._data[index] = item
 
func fill(value):
	for i in len(_data):
		_data[i] = value
 
func is_in_bounds(x, y):
	return x >= 0 and y >= 0 and x < self.width and y < self.height
 
func _get_index(x, y):
	return (y * self.width) + x
 
