extends Node

enum Faction { HERO, GOON, CIVILIAN }

const RELATIONSHIPS = {
	Faction.HERO: {
		"hostile": [Faction.GOON],
		"friendly": [Faction.CIVILIAN],
		"neutral": [],
		"threat_level": 1
	},
	Faction.GOON: {
		"hostile": [Faction.CIVILIAN, Faction.HERO],
		"friendly": [],
		"neutral": [],
		"threat_level": 1
	},
	Faction.CIVILIAN: {
		"hostile": [Faction.GOON],
		"friendly": [Faction.HERO],
		"neutral": [],
		"threat_level": 0
	}
}

func is_hostile(caller_faction, target_faction) -> bool:
	return target_faction in RELATIONSHIPS[caller_faction]["hostile"]
	
func is_friendly(caller_faction, target_faction) -> bool:
	return target_faction in RELATIONSHIPS[caller_faction]["friendly"]
	
func is_neutral(caller_faction, target_faction) -> bool:
	return target_faction in RELATIONSHIPS[caller_faction]["neutral"]
	
