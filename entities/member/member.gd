class_name Member extends PanelContainer


var guild: Guild:
	set = set_guild
var squad: Squad:
	set = set_squad
var resource: MemberResource:
	set = set_resource


func set_guild(guild_: Guild) -> Member:
	guild = guild_
	guild.members.add_child(self)
	update_tokens()
	return self
	
func set_squad(squad_: Squad) -> Member:
	squad = squad_
	squad.members.add_child(self)
	return self
	
func set_resource(resource_: MemberResource) -> Member:
	resource = resource_
	return self
	
func update_tokens() -> void:
	for token in Global.arr.token:
		var value = 0
		
		if Global.arr.defense.has(token) or Global.arr.progression.has(token):
			value = resource.get("current_" + token)
		else:
			value = resource.get(token)
		
		var token_scene = get_node("%" + token.capitalize())
		
		if value > 0:
			token_scene.value = value
		else:
			if !Global.arr.progression.has(token):
				token_scene.visible = false
