extends Node2D

@onready var tile_map = %TileMap
var screen_size
const SCROLL_SPEED = 4
var scroll = 0
@onready var dino_game = $DinoGame

func _ready():
	screen_size = get_window().size

func _process(delta):
	scroll += SCROLL_SPEED
	if scroll >= screen_size.x:
		scroll = 0
	tile_map.position.x = -scroll

func _on_play_pressed():
	get_tree().change_scene_to_file("res://main.tscn")

func _on_quit_pressed():
	get_tree().quit()
