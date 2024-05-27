extends Node2D

const BOX_DELAY : int = 100
const BOX_RANGE : int = 100
const SCROLL_SPEED = 4
@onready var blue_dragon = %BlueDragon
@onready var box_timer = %BoxTimer
@onready var tile_map = %TileMap
@export var box : PackedScene
var game_running : bool
var game_over : bool
var scroll
var score
var screen_size : Vector2i
var ground_hight : int = 110 #replace
var boxes : Array

func _input(event):
	if !game_over:
		if !game_running:
			pass

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_window().size
	new_game()

func new_game():
	game_running=false
	game_over=false
	score=0
	scroll=0
	boxes.clear()
	box_timer.stop()
	# blue_dragon.reset()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if game_running:
		scroll += SCROLL_SPEED
		if scroll >= screen_size.x:
			scroll = 0
		tile_map.position.x = -scroll
		for box in boxes:
			box.position.x -= SCROLL_SPEED
	else:
		if Input.is_action_pressed("ui_accept"):
			game_running = true
			box_timer.start()
			generate_box()

func generate_box():
	var box = box.instantiate()
	box.position.x = screen_size.x + randi_range(0, BOX_RANGE)
	box.position.y = (screen_size.y - ground_hight)
	box.hit.connect(dino_hit)
	add_child(box)
	boxes.append(box)
	
func dino_hit():
	pass

func _on_box_timer_timeout():
	generate_box()
