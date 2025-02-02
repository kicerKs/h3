extends Resource
class_name HeroSkill

enum Skills{
	ARCHERY,
	OFFENSE,
	ARMORER,
	LOGISTICS,
	LUCK,
	LEADERSHIP,
	ESTATES,
}

@export var skill: Skills
@export var lvl: int

static func new_skill(sk: Skills):
	var hs = HeroSkill.new()
	hs.skill = sk
	hs.lvl = 1
	return hs

static func get_skill_name(sk: Skills):
	match sk:
		Skills.ARCHERY:
			return "Archery"
		Skills.OFFENSE:
			return "Offense"
		Skills.ARMORER:
			return "Armorer"
		Skills.LOGISTICS:
			return "Logistics"
		Skills.LUCK:
			return "Luck"
		Skills.LEADERSHIP:
			return "Leadership"
		Skills.ESTATES:
			return "Estates"
		_:
			return ""

static func get_skill_level_name(lvl: int):
	match lvl:
		1:
			return "Basic"
		2:
			return "Advanced"
		3:
			return "Master"
		_:
			return ""

static func get_skill_name_with_level(sk: Skills, lvl: int):
	return get_skill_level_name(lvl) + " " + get_skill_name(sk)

static func get_skill_description(sk: Skills, lvl: int):
	match [sk, lvl]:
		[Skills.ARCHERY, 1]:
			return "Increases the damage done by range attacking creatures by 10%."
		[Skills.ARCHERY, 2]:
			return "Increases the damage done by range attacking creatures by 25%."
		[Skills.ARCHERY, 3]:
			return "Increases the damage done by range attacking creatures by 50%."
		[Skills.OFFENSE, 1]:
			return "Increases all hand-to-hand damage inflicted by the hero's troops by 10%."
		[Skills.OFFENSE, 2]:
			return "Increases all hand-to-hand damage inflicted by the hero's troops by 20%."
		[Skills.OFFENSE, 3]:
			return "Increases all hand-to-hand damage inflicted by the hero's troops by 30%."
		[Skills.ARMORER, 1]:
			return "Reduces all damage inflicted against the hero's troops by 5%."
		[Skills.ARMORER, 2]:
			return "Reduces all damage inflicted against the hero's troops by 10%."
		[Skills.ARMORER, 3]:
			return "Reduces all damage inflicted against the hero's troops by 15%."
		[Skills.LOGISTICS, 1]:
			return "Increases your hero's movement points over land by 5%."
		[Skills.LOGISTICS, 2]:
			return "Increases your hero's movement points over land by 10%."
		[Skills.LOGISTICS, 3]:
			return "Increases your hero's movement points over land by 15%."
		[Skills.LUCK, 1]:
			return "Increases your hero's luck by 1."
		[Skills.LUCK, 2]:
			return "Increases your hero's luck by 2."
		[Skills.LUCK, 3]:
			return "Increases your hero's luck by 3."
		[Skills.LEADERSHIP, 1]:
			return "Increases your hero's troops' morale by 1."
		[Skills.LEADERSHIP, 2]:
			return "Increases your hero's troops' morale by 2."
		[Skills.LEADERSHIP, 3]:
			return "Increases your hero's troops' morale by 3."
		[Skills.ESTATES, 1]:
			return "A hero contributes 250 credits per day to your cause."
		[Skills.ESTATES, 2]:
			return "A hero contributes 500 credits per day to your cause."
		[Skills.ESTATES, 3]:
			return "A hero contributes 1000 credits per day to your cause."

static func get_skill_icon(sk: Skills):
	match sk:
		_:
			return load("res://assets/ph_icon.png")
