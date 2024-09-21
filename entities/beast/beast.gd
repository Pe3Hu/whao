class_name Beast extends PanelContainer


var flock: Flock:
	set = set_flock
var resource: BeastResource:
	set = set_resource


func set_flock(flock_: Flock) -> Beast:
	flock = flock_
	flock.get_node("%Beasts").add_child(self)
	update_tokens()
	return self
	
func set_resource(resource_: BeastResource) -> Beast:
	resource = resource_
	return self
	
func update_tokens() -> void:
	%Totem.level = resource.level
	%Totem.kind = resource.kind
	%Totem.rarity = resource.rarity
	
	for token in Global.arr.token:
		var value = 0
		
		if Global.arr.defense.has(token) or Global.arr.offense.has(token):
			value = resource.get(token)
			var token_scene = get_node("%" + token.capitalize())
			
			if value > 0:
				token_scene.value = value
			else:
				token_scene.visible = false
