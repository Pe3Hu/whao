class_name MemberResource extends Resource


#region vars
var guild: GuildResource:
	set = set_guild
var profession: String:
	set = set_profession

var current_claw: int
var maximum_claw: int
var current_fang: int
var maximum_fang: int

var current_stamina: int = 10
var maximum_stamina: int = 10
var current_experience: int = 0

var fury: int = 0
var cunning: int = 0
var wisdom: int = 0

var exploration: int = 0
var extraction: int = 0
#endregion


func set_profession(profession_: String) -> MemberResource:
	profession = profession_
	var description = Global.dict.profession.title[profession]
	
	for offense in description.offense:
		set(offense, description.offense[offense])
	
	if description.has("support"):
		for support in description.support:
			set(support, description.support[support])
		
	for defense in description.defense:
		set("maximum_" + defense, description.defense[defense])
		set("current_" + defense, description.defense[defense])
	
	return self
	
func set_guild(guild_: GuildResource) -> MemberResource:
	guild = guild_
	guild.members.append(self)
	return self
