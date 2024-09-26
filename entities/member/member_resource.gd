class_name MemberResource extends Resource


var guild: GuildResource
var statistic: StatisticResource
var inventory: InventoryResource 


func init(guild_: GuildResource, profession_: String) -> MemberResource:
	guild = guild_
	guild.members.append(self)
	statistic = StatisticResource.new()
	statistic.init(self, profession_)
	inventory = InventoryResource.new()
	inventory.init(self)
	return self
