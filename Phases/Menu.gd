extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("GridContainer/Button").connect("pressed", self, "phase1")
	get_node("GridContainer/Button2").connect("pressed", self, "phase2")
	pass # Replace with function body.

func phase1():
	get_tree().change_scene("res://Phases/Phase1.tscn")

func phase2():
	get_tree().change_scene("res://Phases/Phase2.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
