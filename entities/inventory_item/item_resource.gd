class_name ItemResource extends Resource


enum Armor {HELMET, CHEST, GLOVES, PANTS, BOOTS}
enum Weapon {DAGGER, AXE, HAMMER, STAFF, BOW, RIFFLE}
enum Jewellry {NECKLACE, EARRING, RING}

enum Core {BRAIN, HEART, LIVER}
enum Twin {JAW, PAW}
enum Shard {SKIN, BONE, BLOOD, PLANT, ORE}

enum Type {EQUIPMENT, LOOT}
enum Subtype {WEAPON, ARMOR, JEWELLRY, CORE, TWIN, SHARD}

enum Rarity {COMMON, UNCOMMON, RARE, EPIC, LEGENDARY}

@export var type: Type
@export var subtype: Type
@export var rarity: Rarity

@export var name: String
@export var damage: int
@export var defense: int

@export_multiline var description: String
@export var texture: Texture2D
