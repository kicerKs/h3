extends Resource
class_name HeroAttributes

@export_category("Character")
@export var name: String
@export var icon: Texture2D

@export_category("Stats")
@export var attack: int
@export var defense: int
@export var _luck = 0
@export var _morale = 0

@export_category("Skills")
@export var _skills: Array[HeroSkill]

# Get pairs skill - lvl

func get_skills():
	var output = []
	for hs in _skills:
		output.append(hs.skill)
	return output

func get_skill_lvl(skill: HeroSkill.Skills):
	for hs in _skills:
		if skill == hs.skill:
			return hs.lvl
	return 0

func upgrade_skill(skill: HeroSkill.Skills):
	for hs in _skills:
		if skill == hs.skill:
			hs.lvl += 1

# Getting values from skills

func get_archery_modifier():
	if HeroSkill.Skills.ARCHERY in get_skills():
		match get_skill_lvl(HeroSkill.Skills.ARCHERY):
			1:
				return 1.1
			2:
				return 1.25
			3:
				return 1.5
	return 1

func get_offence_modifier():
	if HeroSkill.Skills.OFFENSE in get_skills():
		match get_skill_lvl(HeroSkill.Skills.OFFENSE):
			1:
				return 1.1
			2:
				return 1.2
			3:
				return 1.3
	return 1

func get_armorer_modifier():
	if HeroSkill.Skills.ARMORER in _skills:
		match get_skill_lvl(HeroSkill.Skills.ARMORER):
			1:
				return 0.95
			2:
				return 0.9
			3:
				return 0.85
	return 1

func get_logistics_modifier():
	if HeroSkill.Skills.LOGISTICS in get_skills():
		match get_skill_lvl(HeroSkill.Skills.LOGISTICS):
			1:
				return 1.05
			2:
				return 1.1
			3:
				return 1.2
	return 1

func get_luck_modifier():
	if HeroSkill.Skills.LUCK in get_skills():
		match get_skill_lvl(HeroSkill.Skills.LUCK):
			1:
				return 1
			2:
				return 2
			3:
				return 3
	return 0

func get_leadership_modifier():
	if HeroSkill.Skills.LEADERSHIP in get_skills():
		match get_skill_lvl(HeroSkill.Skills.LEADERSHIP):
			1:
				return 1
			2:
				return 2
			3:
				return 3
	return 0

func get_estates_modifier():
	if HeroSkill.Skills.ESTATES in _skills:
		match get_skill_lvl(HeroSkill.Skills.ESTATES):
			1:
				return 250
			2:
				return 500
			3:
				return 1000
	return 0

# Adding, checking and levelup

func add_skill(skill: HeroSkill.Skills):
	if can_add_new_skill() and skill not in get_skills():
		_skills.append(HeroSkill.new_skill(skill))
	elif can_add_skill(skill):
		upgrade_skill(skill)

func has_skill(skill: HeroSkill.Skills) -> bool:
	if skill in get_skills():
		return true
	return false

func can_add_new_skill() -> bool:
	if len(_skills) < 4:
		return true
	return false

func can_add_skill(skill: HeroSkill.Skills) -> bool:
	if (skill not in get_skills() and can_add_new_skill()) or (skill in get_skills() and get_skill_lvl(skill) < 3):
		return true
	return false

func get_level_up_random_skills():
	var selection = []
	if can_add_new_skill():
		var pool = HeroSkill.Skills.values()
		for skill in get_skills():
			pool.erase(skill)
		selection.append([pool.pick_random(), 1])
		if len(get_skills()) == 0:
			pool.erase(selection[0][0])
			selection.append([pool.pick_random(), 1])
	var pool = []
	for skill in HeroSkill.Skills.values():
		if has_skill(skill):
			pool.append(skill)
	while len(selection) < 2:
		if len(pool)<=0:
			break
		var sel = pool.pick_random()
		pool.erase(sel)
		selection.append([sel, get_skill_lvl(sel)+1])
	selection.reverse()
	return selection
