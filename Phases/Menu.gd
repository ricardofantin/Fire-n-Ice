extends Control

var tutorial_index = 0
var current_scene = null

func _ready():
	get_node("Tutorials/TutorialButton").connect("pressed", self, "phase0", [0])
	get_node("Tutorials/Tutorial2").connect("pressed", self, "phase0", [1])
	get_node("Tutorials/Tutorial3").connect("pressed", self, "phase0", [2])
	get_node("Tutorials/Tutorial4").connect("pressed", self, "phase0", [3])
	get_node("Tutorials/Tutorial5").connect("pressed", self, "phase0", [4])
	get_node("Tutorials/Tutorial6").connect("pressed", self, "phase0", [5])
	get_node("GridContainer/Button").connect("pressed", self, "phase1")
	get_node("GridContainer/Button2").connect("pressed", self, "phase2")
	get_node("GridContainer/Button3").connect("pressed", self, "phase3")

func menu_hide():
	get_node("GridContainer").visible = false
	get_node("RichTextLabel").visible = false
	get_node("Tutorials").visible = false

func menu_show():
	get_node("GridContainer").visible = true
	get_node("RichTextLabel").visible = true
	get_node("Tutorials").visible = true

func scene_close():
	if current_scene != null:
		remove_child(current_scene)
		current_scene = null
	menu_show()

func change_to_current_scene():
	menu_hide()
	add_child(current_scene)
	current_scene.connect("mission_end", self, "scene_close")

func phase0(tutorial_index):
	match tutorial_index:
		0:
			current_scene = preload("res://Phases/Phase_1-1.tscn").instance()
		1:
			current_scene = preload("res://Phases/Phase_1-2.tscn").instance()
		2:
			current_scene = preload("res://Phases/Phase_1-3.tscn").instance()
		3:
			current_scene = preload("res://Phases/Phase_1-4.tscn").instance()
		4:
			current_scene = preload("res://Phases/Phase_1-5.tscn").instance()
		5:
			current_scene = preload("res://Phases/Phase_1-6.tscn").instance()
	print(tutorial_index)
	change_to_current_scene()

func phase1():
	current_scene = preload("res://Phases/Phase1.tscn").instance()
	change_to_current_scene()

func phase2():
	current_scene = preload("res://Phases/Phase2.tscn").instance()
	change_to_current_scene()

func phase3():
	current_scene = preload("res://Phases/Phase3.tscn").instance()
	change_to_current_scene()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event):
	# Mouse in viewport coordinates
	if event is InputEventMouseButton:
		# Divide screen in four with main and secondary diagonals
		# which side the screen was clicked
		# screen width 1024, height 600
		var x = event.position[0]
		var y = event.position[1]
		var upper_right = x > y
		var second_diagonal_y = 600 - x*(600.0/1024)
		var upper_left = y < second_diagonal_y
		#print(upper_right, second_diagonal_y, upper_left)
		var action
		if upper_right and upper_left:
			action = 'ui_up'
		elif upper_right and not upper_left:
			action = 'ui_right'
		elif not upper_right and upper_left:
			action = 'ui_left'
		else:
			action = 'ui_down'
		var ev = InputEventAction.new()
		# Set as move_left, pressed.
		ev.action = action
		ev.pressed = event.pressed
		Input.parse_input_event(ev)
		#print(action, event.pressed)
