extends Node2D


export var max_helth = 100
export var jump_power = 500
export var gravity = 9.8
export var speed = 100
export var jump_max = 3
export var jump_count = 0
export var action_timer = 0.1
var vel = Vector2()

enum KeyPress {
	UP, DOWN
}


onready var player = $KinematicBody2D
onready var player_sprite = $KinematicBody2D/AnimatedSprite
onready var helthy_bar = $KinematicBody2D/health


func _process(delta):
	vel.y += gravity

	if helthy_bar.value >= max_helth:
		helthy_bar.hide()
	else:
		helthy_bar.show()

	if vel.y > 0 and not player.is_on_floor():
		player_sprite.play("jump_down")
	if vel.y < 0:
		player_sprite.play("jump_up")
	if player.is_on_floor():
		helthy_bar.value += 5*delta
		jump_count = 0
		player_sprite.play("run")
	if key_press(KeyPress.UP) and $ActionTimer.is_stopped():
		_jump(delta)
	if key_press(KeyPress.DOWN) and $ActionTimer.is_stopped() and not player.is_on_floor():
		_fall(delta)

func _jump(delta):
	if jump_count < jump_max:
		player_sprite.stop()
		player_sprite.play("jump_up")
		jump_count += 1
		vel.y = -jump_power
		$ActionTimer.start(action_timer)
		helthy_bar.value -= 10

func _fall(delta):
	jump_count = jump_max
	player_sprite.stop()
	player_sprite.play("jump_down")
	vel.y += gravity*10 
	

func _physics_process(delta):
	vel = player.move_and_slide(vel, Vector2.UP)

# press
func key_press(name):
	match name :
		KeyPress.UP:
			return key_press_up(name)
		KeyPress.DOWN:
			return key_press_down(name)
	return false
	
func key_press_up(name):
	if Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_select"):
		return true
	return false

func key_press_down(name):
	if Input.is_action_just_pressed("ui_down"):
		return true
	return false


	

	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
