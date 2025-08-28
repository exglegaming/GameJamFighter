extends Control

@onready var rect:ColorRect = get_child(0);

func show_full():
	rect.size.x = 16

func show_half():
	rect.size.x = 8

func show_none():
	rect.size.x = 0
