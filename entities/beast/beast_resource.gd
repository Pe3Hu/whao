class_name BeastResource extends Resource


var flock: FlockResource:
	set = set_flock
var level: int
var rarity: String
var kind: String

var claw: int
var fang: int

var fury: int = 0
var cunning: int = 0
var wisdom: int = 0


func set_flock(flock_: FlockResource) -> void:
	flock = flock_
	flock.beasts.append(self)
	var description = Global.dict.beast.title[kind]
	
	for _offense in description.offense:
		set(_offense, description.offense[_offense])
	
	for _i in Global.arr.offense.size():
		var defense = Global.arr.offense[_i]
		set(defense, description.level[level][_i])
	
	var mutation = int(description.level[level].back())
	
	while mutation > 0:
		var defense = Global.arr.offense.pick_random()
		var max_value = max(1, int(mutation * 0.33))
		var value = randi_range(1, max_value)
		set(defense, get(defense) + value)
		mutation -= value
