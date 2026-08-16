extends State

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const WALK_SPEED:float = 30.0
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
var is_walking = false
var just_turned_around = false
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	$"../../StartWalkingAfterPopup".connect("timeout",self,"on_begin_walking")
	$"../../WalkTimer".connect("timeout",self, "on_fishined_walking")
	$"../../TurnAroundTimer".connect("timeout",self, "on_turn_around_time")

func _enter():
	owner.face_player()
	owner.is_blocking = false
	$"../../AnimationPlayer".play("Stand_Idle")
	$"../../StartWalkingAfterPopup".start()

func _update(delta):
	if is_walking:
		owner.move_and_slide(get_parent().velocity,Vector2.UP)
		if owner.is_on_wall() and not just_turned_around:
			owner.set_flip_direction(!owner.flip_direction)
			just_turned_around = true
			get_parent().velocity.x = WALK_SPEED * owner.get_facing_direction().x
			$"../../TurnAroundTimer".start()
		if not owner.is_on_floor():
			jump()
	else:
		owner.move_and_slide(get_parent().velocity,Vector2.UP)

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func jump():
	is_walking = false
	$"../../WalkTimer".stop()
	$"../../StartWalkingAfterPopup".stop()
	emit_signal("finished", "jump")
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------
func on_begin_walking():
	is_walking  = true
	get_parent().velocity.x = WALK_SPEED * owner.get_facing_direction().x
	$"../../AnimationPlayer".play("Walk")
	var walk_duration = Physics.rng.randf_range(1.0,3.0)
	$"../../WalkTimer".wait_time = walk_duration
	$"../../WalkTimer".start()

func on_fishined_walking():
	is_walking = false
	get_parent().velocity = Vector2.ZERO
	emit_signal("finished","sinkdown")

func on_turn_around_time():
	just_turned_around = false
