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
