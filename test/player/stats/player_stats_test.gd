# GdUnit generated TestSuite
class_name PlayerStatsTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://src/player/stats/player_stats.gd'

func test_reset() -> void:
	# remove this line and complete your test
	var s = load(__source).new()
	s.reset()
	assert_int(s._current_health).is_equal(s.MAX_HEALTH)

func test_take_damage() -> void:
	var s = load(__source).new()
	s.reset()
	
	var damage = 53
	s.take_damage(damage)
	assert_int(s._current_health).is_equal(s.MAX_HEALTH - damage)\
	.is_not_equal(s.MAX_HEALTH)


func test_heal() -> void:
	var s = load(__source).new()
	s.reset()
	
	var heal = 10
	
	s.heal(heal)
	assert_int(s._current_health).is_equal(s.MAX_HEALTH)\
	.is_not_equal(s.MAX_HEALTH + heal)
	
	s._current_health = 50
	s.heal(heal)
	assert_int(s._current_health).is_equal(50 + heal)
