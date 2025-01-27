extends Node
class_name HeroSkills

enum Skills{
	ARCHERY,
	OFFENSE,
	ARMORER,
	LOGISTICS,
	LUCK,
	LEADERSHIP,
	ESTATES,
}

var _skills = []
var _skill_levels = {}

# Getting values from skills

func get_archery_modifier():
	if Skills.ARCHERY in _skills:
		match _skill_levels[Skills.ARCHERY]:
			1:
				return 1.1
			2:
				return 1.25
			3:
				return 1.5
	return 1

func get_offence_modifier():
	if Skills.OFFENSE in _skills:
		match _skill_levels[Skills.OFFENSE]:
			1:
				return 1.1
			2:
				return 1.2
			3:
				return 1.3
	return 1

func get_armorer_modifier():
	if Skills.ARMORER in _skills:
		match _skill_levels[Skills.ARMORER]:
			1:
				return 0.95
			2:
				return 0.9
			3:
				return 0.85
	return 1

func get_logistics_modifier():
	if Skills.LOGISTICS in _skills:
		match _skill_levels[Skills.LOGISTICS]:
			1:
				return 1.05
			2:
				return 1.1
			3:
				return 1.2
	return 1

func get_luck_modifier():
	if Skills.LUCK in _skills:
		match _skill_levels[Skills.LUCK]:
			1:
				return 1
			2:
				return 2
			3:
				return 3
	return 0

func get_leadership_modifier():
	if Skills.LEADERSHIP in _skills:
		match _skill_levels[Skills.LEADERSHIP]:
			1:
				return 1
			2:
				return 2
			3:
				return 3
	return 0

func get_estates_modifier():
	if Skills.ESTATES in _skills:
		match _skill_levels[Skills.ESTATES]:
			1:
				return 250
			2:
				return 500
			3:
				return 1000
	return 0

# Adding, checking and levelup

func add_skill(skill: Skills):
	if can_add_new_skill():
		_skills.append(skill)
		_skill_levels[skill] = 1
	elif can_add_skill(skill):
		_skill_levels[skill] += 1

func has_skill(skill: Skills) -> bool:
	if skill in _skills:
		return true
	return false

func can_add_new_skill() -> bool:
	if len(_skills) < 4:
		return true
	return false

func can_add_skill(skill: Skills) -> bool:
	if can_add_new_skill() or (skill in _skills and _skill_levels[skill] < 3):
		return true
	return false

func get_level_up_random_skills():
	var selection = []
	if can_add_new_skill():
		var pool = Skills.values()
		for skill in _skills:
			pool.erase(skill)
		selection.append([pool.pick_random(), 1])
		if len(_skill_levels) == 0:
			pool.erase(selection[0][0])
			selection.append([pool.pick_random(), 1])
	var pool = []
	for skill in _skill_levels.keys():
		if can_add_skill(skill):
			pool.append(skill)
	while len(selection) < 2:
		if len(pool)<=0:
			break
		var sel = pool.pick_random()
		pool.erase(sel)
		selection.append([sel, _skill_levels[sel]+1])
	return selection
