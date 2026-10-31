extends Resource
class_name CrewMember

@export var needs : int
@export var crew_member_name : String
@export var strength : int = 100

signal crew_member_stats_changed

### Resource object for crew members.
### For now, they just have needs, which for now is just food/water from the ship's stores but it should also be able to be other stuff too
### They also have a name
### They should eventually have a strength value based on how starving they are

func eat(amount):
	if amount == needs:
		strength = 100 ### For now, getting full meals resets character to full strength
	else:
		strength -= 3 * (1.0 - (float(amount) / float(needs)))
	crew_member_stats_changed.emit()
