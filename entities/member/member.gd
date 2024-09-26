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
	return self
	
func set_squad(squad_: Squad) -> Member:
	squad = squad_
	squad.members.add_child(self)
	return self
	
func set_resource(resource_: MemberResource) -> Member:
	resource = resource_
	return self
