extends StateMachine

var input_direction := Vector2()
var locked := false

onready var _inputs: InputHandler = $"../Inputs"

func _ready() -> void:
	states_map = {
		#"spawn": $Spawn,
		"idle": $Idle,
		"move": $Move,
		"jump": $Jump,
		"jump_shoot": $JumpShoot,
		"slide": $Slide,
		"hurt": $Hurt,
		"climb": $Climb,
		"climb_shoot": $ClimbShoot,
		"death": $Death,
		"high-bounce": $Bounce,
		"bomb-boost": $BombBoost,
		"do_nothing": $DoNothing,
		"caught": $Caught,
		"fly_up": $FlyUp,
		"fly_side": $FlySide,
		"spring-bounce": $SpringBounce,
		"stun": $Stun,
		"beam-boost": $BeamBoost,
		"fall": $Fall,
		"thrown": $Thrown,
		"crab_caught":$CrabCaught
	}

func _change_state(state_name: String) -> void:
	if not active or locked:
		return
		owner._ladder_raycast.enabled = false
	if state_name in ["placeholder"]:
		states_stack.push_front(states_map[state_name])
	if state_name == "jump_shoot" and current_state == $Jump:
		$JumpShoot.preset($Jump.velocity)
	if state_name == "idle" and current_state == $Jump:
		$Idle.preset($Jump.velocity)
	if state_name == "move" and current_state == $Slide:
		$Move.preset($Slide.velocity)
	if state_name == "move" and current_state == $Idle:
		if $Idle.was_preset:
			$Move.preset()
	if state_name == "jump_shoot" and current_state == $Bounce:
		$JumpShoot.preset($Bounce.velocity)
	if state_name == "jump_shoot" and current_state == $BombBoost:
		$JumpShoot.preset($BombBoost.velocity)
	if state_name == "jump_shoot" and current_state == $BeamBoost:
		$JumpShoot.preset($BeamBoost.velocity)
	if state_name == "jump_shoot" and current_state == $SpringBounce:
		$JumpShoot.preset($SpringBounce.velocity)
		
		#the following are for springs
	if state_name == "bomb-boost" and current_state == $Jump:
		$BombBoost.preset($Jump.velocity)
	if state_name == "beam-boost" and current_state == $Jump:
		$BeamBoost.preset($Jump.velocity)
	if state_name == "high-bounce" and current_state == $Jump:
		$Bounce.preset($Jump.velocity)
	if state_name == "spring-bounce" and current_state == $Jump:
		$SpringBounce.preset($Jump.velocity)
	if state_name == "bomb-boost" and current_state == $JumpShoot:
		$BombBoost.preset($JumpShoot.velocity)
	if state_name == "high-bounce" and current_state == $JumpShoot:
		$Bounce.preset($JumpShoot.velocity)
	if state_name == "spring-bounce" and current_state == $JumpShoot:
		$SpringBounce.preset($JumpShoot.velocity)
	if state_name == "spring-bounce" and current_state == $SpringBounce:
		$SpringBounce.preset($SpringBounce.velocity)
	if state_name == "spring-bounce" and current_state == $Bounce:
		$SpringBounce.preset($Bounce.velocity)
	if state_name == "spring-bounce" and current_state == $BombBoost:
		$SpringBounce.preset($BombBoost.velocity)
	if state_name == "high-bounce" and current_state == $Bounce:
		$Bounce.preset($Bounce.velocity)
	if state_name == "high-bounce" and current_state == $SpringBounce:
		$Bounce.preset($SpringBounce.velocity)
		
	if state_name == "jump" and current_state == $JumpShoot:
		$Jump.preset($JumpShoot.velocity)
	if state_name == "jump" and current_state == $Slide:
		$Jump.preset($Slide.velocity)
	if state_name == "jump" and current_state == $Hurt:
		$Jump.preset($Hurt.velocity)
	if state_name != "move" and current_state == $Idle:
		owner.is_still = false
		
		#the following are all for keeping momentum on ice
	if state_name == "idle" and current_state == $JumpShoot:
		$Idle.preset($JumpShoot.velocity)
	if state_name == "idle" and current_state == $BombBoost:
		$Idle.preset($BombBoost.velocity)
	if state_name == "idle" and current_state == $Bounce:
		$Idle.preset($Bounce.velocity)
	if state_name == "idle" and current_state == $SpringBounce:
		$Idle.preset($SpringBounce.velocity)
	
	if owner.state_machine_lockdown:
		if owner.is_on_floor():
			state_name = "idle"
		else:
			state_name = "jump"
	._change_state(state_name)

func _physics_process(_delta: float) -> void:
	if not owner.state_machine_lockdown:
		if !owner.is_forced_fall:
			input_direction = _inputs.get_input_direction()
		else:
			input_direction = Vector2.ZERO
	else:
		input_direction = Vector2.ZERO
