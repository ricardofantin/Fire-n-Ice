extends TileMap

enum elements {EMPTY = -1, WALL = 0, ICE = 1, ICE_LEFT = 2,
			   ICE_MIDDLE = 3, ICE_RIGHT = 4, FIRE = 5, PLAYER = 6}

func _ready():
	pass # Replace with function body.

func is_ice(x, y):
	if (get_cell(x, y) == elements.ICE || get_cell(x, y) == elements.ICE_LEFT ||
		get_cell(x, y) == elements.ICE_MIDDLE || get_cell(x, y) == elements.ICE_RIGHT):
		return true
	return false

func is_icev(v):
	return is_ice(v.x, v.y)

func can_create_destroy_ice(x, y):
	if (get_cell(x, y) == elements.EMPTY or is_ice(x, y)):
		return true
	return false

func can_create_destroy_icev(v):
	return can_create_destroy_ice(v.x, v.y)

func is_solid(x, y):
	if (get_cell(x, y) != elements.FIRE and get_cell(x, y) != elements.EMPTY):
		return true
	return false

func is_solidv(v):
	return is_solid(v.x, v.y)

#private
func reduce_ice(x, y): # [TODO] change to update
	# already know it is ice and it can be reduced
	assert(is_ice(x, y)) # it is ice
	var ice_type = get_cell(x, y)
	match ice_type:
		elements.ICE:
			# do not update
			pass
		elements.ICE_LEFT:
			if (! is_solid( x + 1, y) ):
				set_cell(x, y, elements.ICE)
		elements.ICE_RIGHT:
			if (! is_solid( x - 1, y) ):
				set_cell(x, y, elements.ICE)
		elements.ICE_MIDDLE:
			if ( is_solid( x - 1, y) ):
				set_cell(x, y, elements.ICE_RIGHT)
			else:
				set_cell(x, y, elements.ICE_LEFT)

#private
#func create_ice(x, y):
#	pass

func is_ice_floating(x, y):
	# is an left or an right edge?
	var check_direction
	if is_ice(x-1, y):
		check_direction = -1
	else:
		check_direction = 1
	# go until do not find ice
	var x_end = x + check_direction
	while is_ice(x_end, y):
		x_end += check_direction
	if is_solid(x_end, y):
		return false
	return true

# create or destroy ice in v
func create_destroy_ice(x, y):
	if (is_ice(x, y)):
		# destroy ice
		set_cell(x, y, elements.EMPTY)
		# check if some ice should fall
		if (is_ice(x - 1, y)):
			reduce_ice(x - 1, y)
			var x_end = x - 2
			while is_ice(x_end, y):
				x_end -= 1
			if get_cell(x_end + 1, y) == elements.ICE_LEFT:
				# ice should fall
				for i in range(x_end, x):
					set_cell(i, y, elements.EMPTY)
				var wide_ice = load("res://Wide_falling_ice.tscn").instance()
				var width = abs(x_end + 1 - x)
				wide_ice.init(width)
				add_child(wide_ice)
				wide_ice.set_position(32*Vector2(x_end + 1, y) + Vector2(16, 16))
		if (is_ice(x + 1, y)):
			reduce_ice(x + 1, y)
			var x_end = x + 2
			while is_ice(x_end, y):
				x_end += 1
			if get_cell(x_end - 1, y) == elements.ICE_RIGHT:
				# [TODO] should fall
				pass
			#if is_ice_floating(x + 1, y):
			#	pass # [TODO]
	else:
		# create ice
		var left = is_solid(x - 1, y)
		var right = is_solid(x + 1, y)
		if (left and right):
			set_cell(x, y, elements.ICE_MIDDLE)
		elif (left):# (right == false)
			set_cell(x, y, elements.ICE_RIGHT)
		elif (right):# (left == false)
			set_cell(x, y, elements.ICE_LEFT)
		else:# (left == false and right == false)
			assert(false)# bug, should never happen. Player coordinates right?
		if (is_ice(x - 1, y)):
			if (get_cell(x - 1, y) == elements.ICE_RIGHT):
				set_cell(x - 1, y, elements.ICE_MIDDLE)
			else:# is alone ice
				set_cell(x - 1, y, elements.ICE_LEFT)
		if (is_ice(x + 1, y)):
			if (get_cell(x + 1, y) == elements.ICE_LEFT):
				set_cell(x + 1, y, elements.ICE_MIDDLE)
			else:# is alone ice
				set_cell(x + 1, y, elements.ICE_RIGHT)

func create_destroy_icev(v):
	return create_destroy_ice(v.x, v.y)

func is_win():
	var x = 0
	var y = 0
	while (get_cell(x, 0) != elements.EMPTY):
		x += 1
	while (get_cell(0, y) != elements.EMPTY):
		y += 1
	for l in range(y):
		for c in range(x):
			if (get_cell(c, l) == elements.FIRE):
				return false
	return true
