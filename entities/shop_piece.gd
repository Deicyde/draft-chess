extends Node2D

@export var piece_type_str = 'p'

func _ready() -> void:
	reset()

func reset():
	get_node("Sprite2D").texture = Globals.pieceManager.get_texture(piece_type_str)
	
