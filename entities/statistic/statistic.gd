class_name Statistic extends PanelContainer


@export var member: Member
var resource: StatisticResource


func init(member_: Member, resource_: StatisticResource) -> void:
	member = member_
	resource = resource_
	custom_minimum_size = resource_.cms
	update_tokens()
	
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
