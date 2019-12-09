extends Node

const PlayerGroup := "Player"
const EnemyGroup := "Enemies"

const UNIT_SIZE := 64.0

# https://godotengine.org/qa/28776/rotate-kinematicbody2d-based-mouse-position-varying-rate
func lerp_angle(a, b, t):
	if(abs(a-b)) >= PI:
		if a > b:
			b += 2 * PI
		else:
			a += 2 * PI
	
	# Radians
	return lerp(a, b, t)
