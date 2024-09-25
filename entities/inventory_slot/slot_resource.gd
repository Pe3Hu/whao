class_name SlotResource extends Resource


enum Type {ANY, EQUIPMENT, LOOT}
enum Subtype {ANY, WEAPON, ARMOR, JEWELLRY, CORE, TWIN, SHARD}
enum Kind {
	ANY, 
	HELMET, CHEST, GLOVES, PANTS, BOOTS,
	DAGGER, AXE, HAMMER, STAFF, BOW, RIFFLE,
	NECKLACE, EARRING, RING,
	BRAIN, HEART, LIVER,
	JAW, PAW,
	SKIN, BONE, BLOOD, PLANT, ORE
	}

@export var type: Type
@export var subtype: Subtype
@export var kind: Kind
@export var rarity: ItemResource.Rarity

@export_range(1, 9, 1) var level: int
@export_range(0, 99, 1) var current_stack: int
@export_range(1, 99, 1) var max_stack: int

const cms = Vector2(32, 32)
