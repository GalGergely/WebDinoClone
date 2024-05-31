extends Node2D

const BOX_DELAY : int = 100
const BOX_RANGE : int = 100
const SCROLL_SPEED = 4

@onready var blue_dragon = %BlueDragon
@onready var box_timer = %BoxTimer
@export var box : PackedScene
@onready var background = %Background
@onready var tile_map = $TileMap
@onready var press_enter_label = %PressEnter
@onready var you_died = $YouDied

var game_running : bool
var game_over : bool
var scroll
var score
var screen_size : Vector2i
var ground_hight : int = 105 #replace
var boxes : Array

func show_or_hode_youdied_label():
	if game_over:
		you_died.show()
	else:
		you_died.hide()
		
func show_or_remove_enter_label():
	if !game_running:
		press_enter_label.show()
	else:
		press_enter_label.hide()
		

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
	print(boxes)
	# TODO: itt a box kitörlödik a boxes tombbol, de a gyerekek valahogy ottmaradnak, tehát ami a képernyon volt doboz aktuálisan, beragad
	# gondolom valami remove child kellene.
	boxes.clear()
	print(boxes)
	box_timer.stop()
	blue_dragon.reset()
	
func start_game():
	game_running=true
	box_timer.start()
	generate_box()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	show_or_hode_youdied_label()
	show_or_remove_enter_label()
	if game_running:
		scroll += SCROLL_SPEED
		if scroll >= screen_size.x:
			scroll = 0
		background.scroll_base_offset -= Vector2(100, 0) * delta
		tile_map.position.x = -scroll
		for box in boxes:
			box.position.x -= SCROLL_SPEED
	else:
		if Input.is_action_pressed("ui_accept"):
			new_game()
			start_game()

func generate_box():
	var box = box.instantiate()
	box.position.x = screen_size.x + randi_range(0, BOX_RANGE)
	box.position.y = (screen_size.y - ground_hight)
	box.hit.connect(dino_hit)
	add_child(box)
	boxes.append(box)
	
func dino_hit():
	stop_game()
	

func stop_game():
	game_over = true
	game_running = false
	box_timer.stop()
	

func _on_box_timer_timeout():
	generate_box()
