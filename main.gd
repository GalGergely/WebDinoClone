extends Node2D

const BOX_DELAY : int = 100
const SCROLL_SPEED = 4
@onready var blue_dragon = %BlueDragon
@onready var tile_map = %TileMap

var game_running : bool
var game_over : bool
var scroll
var score
var screen_size : Vector2i
var ground_hight : int
var boxes : Array



# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_window().size
	new_game()

func new_game():
	game_running=true
	game_over=false
	score=0
	scroll=0
	# blue_dragon.reset()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if game_running:
		scroll += SCROLL_SPEED
		if scroll >= screen_size.x:
			scroll = 0
		tile_map.position.x = -scroll
