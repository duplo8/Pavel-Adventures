extends Node2D



@onready var door_area: Area2D = $door_area
#@export var next_scene: PackedScene 

#@export var next_scene: PackedScene
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("up"):
		if door_area.get_overlapping_areas().any( func(area: Area2D) -> bool: return area.name == "player_area" ):
			if false: #next_scene != null:
				next_level()		#change scene into next scene
			else:
				print("this door leads to nothing")

func next_level() -> void:
	pass
	#finds and deletes this level			--HIGHLY ILLEGAL, QUARANTINED
#	var daddy: Node = $"."
#	while daddy.get_parent() != null :
#		daddy = daddy.get_parent()		
#	daddy.queue_free()
	#goes to next level

#	var ERR = get_tree().change_scene_to_packed(next_scene)
#	if ERR != OK:
#		print("Sum Tin Wong")

	#get_tree().change_scene_to_file(next_scene.get_path()) #changes scene with path



