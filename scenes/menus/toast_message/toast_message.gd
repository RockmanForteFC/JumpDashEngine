extends CanvasLayer

#-------------------------------------------------
#      Constants
#-------------------------------------------------

#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
export(String) var message:String = "some message here"
onready var label = $toast/Control2/Label
export(String, "trophy","disc","challenge","enemy","midboss") var icon: String = "trophy"
onready var animation = $AnimationPlayer

onready var trophy = load("res://assets/images/sprites/menus/trophy.png")
onready var disc = load("res://assets/images/sprites/menus/disc.png")
onready var challenge = load("res://assets/images/sprites/menus/crown.png")
onready var enemy_bestiary = load("res://assets/images/sprites/menus/bestiary_icon.png")
onready var midboss_besiary = load("res://assets/images/sprites/menus/bestiary_miniboss_icon.png")
onready var record = load("res://assets/images/sprites/menus/record_icon.png")
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	$Toast.play()
	if icon == "disc":
		$toast/Control/Icon.texture = disc
	elif icon == "trophy":
		$toast/Control/Icon.texture = trophy
	elif icon == "challenge":
		$toast/Control/Icon.texture = challenge
	elif icon == "enemy":
		$toast/Control/Icon.texture = enemy_bestiary
	elif icon == "midboss":
		$toast/Control/Icon.texture = midboss_besiary
	elif icon == "record":
		$toast/Control/Icon.texture = record
	elif icon == "nothing":
		$toast/Control/Icon.texture = null
	label.text =  message
	animation.play("Show")

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------


func _on_toast_state_changed(anim_name):
	if anim_name == "Show":
		animation.play("Wait")
	if anim_name == "Wait":
		animation.play("Hide")
	if anim_name == "Hide":
		queue_free()
