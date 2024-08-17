extends Area2D
signal hit 
#how fast the player will move ingame.
@export var speed =500
#screen size of the game  
var screen_size 

func _ready():
	screen_size = get_viewport_rect().size 
	hide()
	
func _process(delta):
	var velocity: Vector2 = Vector2.ZERO  #player movement vector starts at 0,0 
	#input to change vector in x and y axis 
	if Input.is_action_pressed("left"):
		velocity.x -= 1
	if Input.is_action_pressed("right"):
		velocity.x += 1
	if Input.is_action_pressed("up"):
		velocity.y -= 1
	if Input.is_action_pressed("down"):
		velocity.y += 1
	
	if velocity.length() > 0 :
		velocity = velocity.normalized() * speed 
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
	position += velocity * delta 
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false 
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y >0
		
	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
	if velocity.x <0 : 
		$AnimatedSprite2D.flip_h = true


func _on_body_entered(_body):
	hide() # Player disappears after being hit.
	hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)
	
func start (pos):
	position = pos 
	show()
	$CollisionShape2D.disabled = false 
