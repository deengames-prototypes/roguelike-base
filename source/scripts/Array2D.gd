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
 
func has(coordinates:Vector2i):
	var x = coordinates.x
	var y = coordinates.y
	if x < 0 or x >= self.width or y < 0 or y >= self.height:
		pass #("Invalid coordinates: %s, %s" % [x, y])
		return false
	else:
		var index = self._get_index(coordinates)
		return self._data[index] != null
 
func get_at(coordinates:Vector2i):
	var x = coordinates.x
	var y = coordinates.y
	
	if x < 0 or x >= self.width or y < 0 or y >= self.height:
		pass #("Invalid coordinates: %s, %s" % [x, y])
		return null
	else:
		var index = self._get_index(coordinates)
		return self._data[index]
 
func set_at(coordinates:Vector2i, item):
	var x = coordinates.x
	var y = coordinates.y
	if x < 0 or x >= self.width or y < 0 or y >= self.height:
		pass #("Invalid coordinates: %s, %s" % [x, y])
	else:
		var index = self._get_index(coordinates)
		self._data[index] = item
 
func fill(value):
	for i in len(_data):
		_data[i] = value
 
func is_in_bounds(coordinates:Vector2i) -> bool:
	return coordinates.x >= 0 and coordinates.y >= 0 and \
	coordinates.x < self.width and coordinates.y < self.height
 
func _get_index(coordinates:Vector2i):
	return (coordinates.y * self.width) + coordinates.x
 
