extends KinematicBody2D

var width

export(Texture) var tex_left
export(Texture) var tex_right
export(Texture) var tex_middle
export(Texture) var tex_alone

func _init():
	pass

func init(width):
	self.width = width
	# modify CollisionShape size
	var collision = get_child(0)
	collision.set_position(Vector2(16*width - 16, 0))
	var shape = collision.get_shape()
	shape.set_extents(Vector2(15*width, 16))
	# create all sprites
	if width == 1:
		var ice = Sprite.new()
		ice.set_texture(tex_alone)
		self.add_child(ice)
		ice.set_position(Vector2(0, 0))
	else:
		var ice_left = Sprite.new()
		ice_left.set_texture(tex_left)
		self.add_child(ice_left)
		ice_left.set_position(Vector2(0, 0))
		var ice_right = Sprite.new()
		ice_right.set_texture(tex_right)
		self.add_child(ice_right)
		ice_right.set_position(Vector2(32*(width-1), 0))
		for i in range(1,width-1):
			var ice = Sprite.new()
			ice.set_texture(tex_middle)
			self.add_child(ice)
			ice.set_position(Vector2(32*(i), 0))

func _physics_process(_delta):
	var __ = move_and_slide(Vector2(0, 32*5), Vector2(0, -1))
	if ( is_on_floor() ):
		# verify in what it collided. Was solid? If not, was fire?
		var my_x = int(get_position().x/32)
		var my_y = int(get_position().y/32)
		width = width
		var tilemap = self.get_parent()
		for i in range(my_x, my_x + width):
			if tilemap.is_solid(i, my_y + 1):
				if width == 1:
					tilemap.set_cell(i, my_y, tilemap.elements.ICE)
					tilemap.remove_child(self)
				else:
					tilemap.set_cell(my_x, my_y, tilemap.elements.ICE_LEFT)
					tilemap.set_cell(my_x + width - 1, my_y, tilemap.elements.ICE_RIGHT)
					for j in range(my_x + 1, my_x + width - 1):
						tilemap.set_cell(j, my_y, tilemap.elements.ICE_MIDDLE)
					tilemap.remove_child(self)
				return
		# check if fire
		for i in range(my_x, my_x + width):
			if tilemap.get_cell(i, my_y + 1) == tilemap.elements.FIRE:
				# create two wide_falling_ice
				if i > my_x:
					# first ice
					tilemap.create_falling_ice(my_x, my_y, abs(i - my_x))
				if i < my_x + width - 1:
					# second ice
					tilemap.create_falling_ice(i + 1, my_y, my_x + width - i - 1)
				tilemap.set_cell(i, my_y + 1, tilemap.elements.EMPTY)
				if tilemap.is_win():
					print( "Win" )
					tilemap.print_tree_pretty()
					get_tree().change_scene("res://Phases/Menu.tscn")
				tilemap.remove_child(self)
				return
		assert( false ) # always should touch a solid or a fire
