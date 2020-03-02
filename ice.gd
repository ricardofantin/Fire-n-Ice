extends KinematicBody2D

var direction
var life_cicle = 0

func _ready():
	direction = 0

func set_direction(sliding_direction):
	direction = sliding_direction

func init(sliding_direction):
	direction = sliding_direction

func _physics_process(delta):
	match(life_cicle):
		0:
			move_and_slide(Vector2(0, 32*5), Vector2(0, -1))
			if ( is_on_floor() ):
				life_cicle = 1
		1:
			move_and_slide(direction*Vector2(32 * 3, 0) + Vector2(0, 10), Vector2(0, -1))
			if ( is_on_wall() ):
				life_cicle = 3
			if ( !is_on_floor() ):
				life_cicle = 2
		2:
			move_and_slide(Vector2(0, 32*5), Vector2(0, -1))
			if ( is_on_floor() ):
				life_cicle = 4
		3:
			var tilemap = self.get_parent()
			var pos = get_position()
			pos.x = int(pos.x/32) + direction
			pos.y = int(pos.y/32)
			if ( tilemap.get_cellv(pos) == 2 ): # 2 is Fire
				tilemap.set_cellv(pos, -1)
				get_tree().change_scene("res://Phases/Menu.tscn")
#				tilemap.remove_child(self)
			else:
				pos.x -= direction
				tilemap.set_cellv(pos, 1)
				tilemap.remove_child(self)
		4:
			var tilemap = self.get_parent()
			var pos = get_position()
			pos.x = int(pos.x/32)
			pos.y = int(pos.y/32)
			tilemap.set_cellv(pos, 1)
			tilemap.remove_child(self)
