extends Node2D

const obstacle_DELAY : int = 100
const obstacle_RANGE : int = 100
const SCROLL_SPEED = 4
@onready var blue_dragon = %BlueDragon
@onready var obstacle_timer = %BoxTimer
var obstacle_1 = preload("res://Obstacles/obstacle_1.tscn")
var obstacle_2 = preload("res://Obstacles/obstacle_2.tscn")
var obstacle_3 = preload("res://Obstacles/obstacle_3.tscn")
@export var box : PackedScene
@onready var background = %Background
@onready var tile_map = $TileMap
@onready var press_enter_label = %PressEnter
@onready var you_died = $YouDied

var game_running : bool
var game_over : bool
var scroll
var score: int
var screen_size : Vector2i
var ground_hight : int = 105 #replace
var obstacles : Array
var passed_obstacles : Array

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
	obstacles.clear()
	passed_obstacles.clear()
	obstacle_timer.stop()
	blue_dragon.reset()
	get_tree().call_group("obstacles", "queue_free")
	get_tree().call_group("passed_obstacles", "queue_free")
func start_game():
	game_running=true
	obstacle_timer.start()
	generate_obstacle()
	

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
		for obstacle in obstacles:
			obstacle.position.x -= SCROLL_SPEED
			if obstacle.position.x < %BlueDragon.position.x and not passed_obstacles.has(obstacle):
				passed_obstacles.append(obstacle)
				score += 1
		show_score()
	else:
		if Input.is_action_pressed("ui_accept"):
			new_game()
			start_game()

func show_score():
	$HUD.get_node("Score").text = "SCORE: " + str(score)

func generate_obstacle():
	var random = randi_range(1,3)
	var obstacle
	if random == 1:
		obstacle = obstacle_1.instantiate()
	elif random == 2:
		obstacle = obstacle_2.instantiate()
	elif random == 3:
		obstacle = obstacle_3.instantiate()
	else:
		pass
	obstacle.position.x = screen_size.x + randi_range(0, obstacle_RANGE)
	
	obstacle.position.y = (screen_size.y - ground_hight)
	obstacle.hit.connect(dino_hit)
	add_child(obstacle)
	obstacles.append(obstacle)
	
func dino_hit():
	stop_game()
	

func stop_game():
	game_over = true
	game_running = false
	obstacle_timer.stop()
	
func _on_box_timer_timeout():
	generate_obstacle()
