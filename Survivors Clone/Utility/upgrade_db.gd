extends Node

const ICON_PATH = "res://Textures/Items/Upgrades/"
const WEAPON_PATH = "res://Textures/Items/Weapons/"

const UPGRADES = {
	"eye": {
		"icon": WEAPON_PATH + "eye.png",
		"displayname": "Eye of Terror",
		"details": "Summons the Eye of Terror, smiting enemies and making them vulnurable to critical damage",
		"level": "",
		"prerequisite": [],
		"type": "ultimate"
	},
	"scythe": {
		"icon": WEAPON_PATH + "scythe.png",
		"displayname": "Hungering Scythe",
		"details": "Summons the Hungering Scythe, damaging nearby foes and leeching health",
		"level": "",
		"prerequisite": [],
		"type": "ultimate"
	},
	"icespear1": {
		"icon": WEAPON_PATH + "ice_spear.png",
		"displayname": "Ice Spear",
		"details": "A spear of ice is thrown at a random enemy",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "weapon"
	},
	"icespear2": {
		"icon": WEAPON_PATH + "ice_spear.png",
		"displayname": "Ice Spear",
		"details": "An addition Ice Spear is thrown",
		"level": "Level: 2",
		"prerequisite": ["icespear1"],
		"type": "weapon_upgrade"
	},
	"icespear3": {
		"icon": WEAPON_PATH + "ice_spear.png",
		"displayname": "Ice Spear",
		"details": "Ice Spears now pass through another enemy and do more damage",
		"level": "Level: 3",
		"prerequisite": ["icespear2"],
		"type": "weapon_upgrade"
	},
	"icespear4": {
		"icon": WEAPON_PATH + "ice_spear.png",
		"displayname": "Ice Spear",
		"details": "An additional 2 Ice Spears are thrown",
		"level": "Level: 4",
		"prerequisite": ["icespear3"],
		"type": "weapon_upgrade"
	},
	"comet1": {
		"icon": WEAPON_PATH + "Meteor2.png",
		"displayname": "Meteor",
		"details": "A meteor falls, creating damaging zone",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "weapon"
	},
	"comet2": {
		"icon": WEAPON_PATH + "Meteor2.png",
		"displayname": "Meteor",
		"details": "Increase damage zone size",
		"level": "Level: 2",
		"prerequisite": ["comet1"],
		"type": "weapon_upgrade"
	},
	"comet3": {
		"icon": WEAPON_PATH + "Meteor2.png",
		"displayname": "Meteor",
		"details": "An extra meteor falls and increase damage zone damage and damage rate",
		"level": "Level: 3",
		"prerequisite": ["comet2"],
		"type": "weapon_upgrade"
	},
	"comet4": {
		"icon": WEAPON_PATH + "Meteor2.png",
		"displayname": "Meteor",
		"details": "Further increase damage zone size, damage, and meteor count",
		"level": "Level: 4",
		"prerequisite": ["comet3"],
		"type": "weapon_upgrade"
	},
	"fsword1": {
		"icon": WEAPON_PATH + "sword.png",
		"displayname": "Throwing Knife",
		"details": "Throws knifes from the player",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "weapon"
	},
	"fsword2": {
		"icon": WEAPON_PATH + "sword.png",
		"displayname": "Throwing Knife",
		"details": "Throws an additional knife",
		"level": "Level: 2",
		"prerequisite": ["fsword1"],
		"type": "weapon_upgrade"
	},
	"fsword3": {
		"icon": WEAPON_PATH + "sword.png",
		"displayname": "Throwing Knife",
		"details": "Throws more often",
		"level": "Level: 3",
		"prerequisite": ["fsword2"],
		"type": "weapon_upgrade"
	},
	"fsword4": {
		"icon": WEAPON_PATH + "sword.png",
		"displayname": "Throwing Knife",
		"details": "Knives now pass through an additional enemy, throws more often",
		"level": "Level: 4",
		"prerequisite": ["fsword3"],
		"type": "weapon_upgrade"
	},
	"fsword5": {
		"icon": WEAPON_PATH + "sword.png",
		"displayname": "Throwing Knife",
		"details": "Knives now shoot in a circular fashion, occasionaly shoots extra knives",
		"level": "Level: 5",
		"prerequisite": ["fsword4"],
		"type": "weapon_upgrade"
	},
	"katana1": {
		"icon": WEAPON_PATH + "katana.png",
		"displayname": "Katana",
		"details": "Summon a katana in a random location around the player",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "weapon"
	},
	"katana2": {
		"icon": WEAPON_PATH + "katana.png",
		"displayname": "Katana",
		"details": "summon an additional katana",
		"level": "Level: 2",
		"prerequisite": ["katana1"],
		"type": "weapon_upgrade"
	},
	"katana3": {
		"icon": WEAPON_PATH + "katana.png",
		"displayname": "Katana",
		"details": "Katanas grow bigger",
		"level": "Level: 3",
		"prerequisite": ["katana2"],
		"type": "weapon_upgrade"
	},
	"katana4": {
		"icon": WEAPON_PATH + "katana.png",
		"displayname": "Katana",
		"details": "Summon 2 additional katanas, increase base damage",
		"level": "Level: 4",
		"prerequisite": ["katana3"],
		"type": "weapon_upgrade"
	},
	"katana5": {
		"icon": WEAPON_PATH + "katana.png",
		"displayname": "Katana",
		"details": "Summon 4 additional katanas, increase base damage",
		"level": "Level: 5",
		"prerequisite": ["katana4"],
		"type": "weapon_upgrade"
	},
	"trail1": {
		"icon": WEAPON_PATH + "fire_icon.png",
		"displayname": "Fire Trail",
		"details": "Leave a trail of fire behind the player. Duration and damage scales with speed",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "weapon"
	},
	"trail2": {
		"icon": WEAPON_PATH + "fire_icon.png",
		"displayname": "Fire Trail",
		"details": "Increase fire damage",
		"level": "Level: 2",
		"prerequisite": ["trail1"],
		"type": "weapon_upgrade"
	},
	"trail3": {
		"icon": WEAPON_PATH + "fire_icon.png",
		"displayname": "Fire Trail",
		"details": "Increase fire duration",
		"level": "Level: 3",
		"prerequisite": ["trail2"],
		"type": "weapon_upgrade"
	},
	"trail4": {
		"icon": WEAPON_PATH + "fire_icon.png",
		"displayname": "Fire Trail",
		"details": "Increase fire duration and damage",
		"level": "Level: 4",
		"prerequisite": ["trail3"],
		"type": "weapon_upgrade"
	},
	"circle1": {
		"icon": WEAPON_PATH + "hellcircle.png",
		"displayname": "Hell Aura",
		"details": "Spawn an aura of death around the player, damage scales with max HP",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "weapon"
	},
	"circle2": {
		"icon": WEAPON_PATH + "hellcircle.png",
		"displayname": "Hell Aura",
		"details": "Increase aura damage",
		"level": "Level: 2",
		"prerequisite": ["circle1"],
		"type": "weapon_upgrade"
	},
	"circle3": {
		"icon": WEAPON_PATH + "hellcircle.png",
		"displayname": "Hell Aura",
		"details": "Increase aura size",
		"level": "Level: 3",
		"prerequisite": ["circle2"],
		"type": "weapon_upgrade"
	},
	"circle4": {
		"icon": WEAPON_PATH + "hellcircle.png",
		"displayname": "Hell Aura",
		"details": "Decrease aura cooldown",
		"level": "Level: 4",
		"prerequisite": ["circle3"],
		"type": "weapon_upgrade"
	},
	"circle5": {
		"icon": WEAPON_PATH + "hellcircle.png",
		"displayname": "Hell Aura",
		"details": "Increase aura size, damage, and grant life leech",
		"level": "Level: 5",
		"prerequisite": ["circle4"],
		"type": "weapon_upgrade"
	},
	"bow1": {
		"icon": WEAPON_PATH + "bow_icon.png",
		"displayname": "Holy Bow",
		"details": "Spawn a bow that shoots piercing projectiles in a straight line",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "weapon"
	},
	"bow2": {
		"icon": WEAPON_PATH + "bow_icon.png",
		"displayname": "Holy Bow",
		"details": "Shoot an additional arrow",
		"level": "Level: 2",
		"prerequisite": ["bow1"],
		"type": "weapon_upgrade"
	},
	"bow3": {
		"icon": WEAPON_PATH + "bow_icon.png",
		"displayname": "Holy Bow",
		"details": "Shoot an additional arrow and increase damage",
		"level": "Level: 3",
		"prerequisite": ["bow2"],
		"type": "weapon_upgrade"
	},
	"bow4": {
		"icon": WEAPON_PATH + "bow_icon.png",
		"displayname": "Holy Bow",
		"details": "Shoot an additional arrow",
		"level": "Level: 4",
		"prerequisite": ["bow3"],
		"type": "weapon_upgrade"
	},
	"bow5": {
		"icon": WEAPON_PATH + "bow_icon.png",
		"displayname": "Holy Bow",
		"details": "Shoot an additional arrow and increase damage",
		"level": "Level: 5",
		"prerequisite": ["bow4"],
		"type": "weapon_upgrade"
	},
	"firegun1": {
		"icon": WEAPON_PATH + "shotgun.png",
		"displayname": "Fire Gun",
		"details": "Shoot multiple fire pellets in front of the player",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "weapon"
	},
	"firegun2": {
		"icon": WEAPON_PATH + "shotgun.png",
		"displayname": "Fire Gun",
		"details": "Shoot more often",
		"level": "Level: 2",
		"prerequisite": ["firegun1"],
		"type": "weapon_upgrade"
	},
	"firegun3": {
		"icon": WEAPON_PATH + "shotgun.png",
		"displayname": "Fire Gun",
		"details": "Increase pellets base damage",
		"level": "Level: 3",
		"prerequisite": ["firegun2"],
		"type": "weapon_upgrade"
	},
	"firegun4": {
		"icon": WEAPON_PATH + "shotgun.png",
		"displayname": "Fire Gun",
		"details": "Pellets travel farther, shoots twice",
		"level": "Level: 4",
		"prerequisite": ["firegun3"],
		"type": "weapon_upgrade"
	},
		"firegun5": {
		"icon": WEAPON_PATH + "shotgun.png",
		"displayname": "Fire Gun",
		"details": "Shoots more often, increase pellet count",
		"level": "Level: 5",
		"prerequisite": ["firegun4"],
		"type": "weapon_upgrade"
	},
	"hsword1": {
		"icon": WEAPON_PATH + "w_longsword_holy.png",
		"displayname": "Holy Blade",
		"details": "Summons a large blade infront of the player",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "weapon"
	},
	"hsword2": {
		"icon": WEAPON_PATH + "w_longsword_holy.png",
		"displayname": "Holy Blade",
		"details": "Reduce the cooldown of holy blade",
		"level": "Level: 2",
		"prerequisite": ["hsword1"],
		"type": "weapon_upgrade"
	},
	"hsword3": {
		"icon": WEAPON_PATH + "w_longsword_holy.png",
		"displayname": "Holy Blade",
		"details": "Increase the damage of holy blade",
		"level": "Level: 3",
		"prerequisite": ["hsword2"],
		"type": "weapon_upgrade"
	},
	"hsword4": {
		"icon": WEAPON_PATH + "w_longsword_holy.png",
		"displayname": "Holy Blade",
		"details": "Further reduce the cooldown of holy blade",
		"level": "Level: 4",
		"prerequisite": ["hsword3"],
		"type": "weapon_upgrade"
	},
	"javelin1": {
		"icon": WEAPON_PATH + "javelin_3_new_attack.png",
		"displayname": "Javelin",
		"details": "A magical javelin will follow you attacking enemies in a straight line",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "weapon"
	},
	"javelin2": {
		"icon": WEAPON_PATH + "javelin_3_new_attack.png",
		"displayname": "Javelin",
		"details": "The javelin will now attack an additional enemy per attack",
		"level": "Level: 2",
		"prerequisite": ["javelin1"],
		"type": "weapon_upgrade"
	},
	"javelin3": {
		"icon": WEAPON_PATH + "javelin_3_new_attack.png",
		"displayname": "Javelin",
		"details": "The javelin will attack another additional enemy per attack",
		"level": "Level: 3",
		"prerequisite": ["javelin2"],
		"type": "weapon_upgrade"
	},
	"javelin4": {
		"icon": WEAPON_PATH + "javelin_3_new_attack.png",
		"displayname": "Javelin",
		"details": "The javelin now does more damage per attack and causes additional knockback",
		"level": "Level: 4",
		"prerequisite": ["javelin3"],
		"type": "weapon_upgrade"
	},
	"tornado1": {
		"icon": WEAPON_PATH + "tornado.png",
		"displayname": "Tornado",
		"details": "A tornado is created and random heads somewhere in the players direction",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "weapon"
	},
	"tornado2": {
		"icon": WEAPON_PATH + "tornado.png",
		"displayname": "Tornado",
		"details": "An additional Tornado is created",
		"level": "Level: 2",
		"prerequisite": ["tornado1"],
		"type": "weapon_upgrade"
	},
	"tornado3": {
		"icon": WEAPON_PATH + "tornado.png",
		"displayname": "Tornado",
		"details": "Reduce the cooldown of tornado",
		"level": "Level: 3",
		"prerequisite": ["tornado2"],
		"type": "weapon_upgrade"
	},
	"tornado4": {
		"icon": WEAPON_PATH + "tornado.png",
		"displayname": "Tornado",
		"details": "An additional tornado is created and the knockback is increased",
		"level": "Level: 4",
		"prerequisite": ["tornado3"],
		"type": "weapon_upgrade"
	},
	"armor1": {
		"icon": ICON_PATH + "helmet_1.png",
		"displayname": "Armor",
		"details": "Reduces Damage By 1 point",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"armor2": {
		"icon": ICON_PATH + "helmet_1.png",
		"displayname": "Armor",
		"details": "Reduces Damage By an additional 1 point",
		"level": "Level: 2",
		"prerequisite": ["armor1"],
		"type": "upgrade"
	},
	"armor3": {
		"icon": ICON_PATH + "helmet_1.png",
		"displayname": "Armor",
		"details": "Reduces Damage By an additional 1 point",
		"level": "Level: 3",
		"prerequisite": ["armor2"],
		"type": "upgrade"
	},
	"armor4": {
		"icon": ICON_PATH + "helmet_1.png",
		"displayname": "Armor",
		"details": "Reduces Damage By an additional 1 point",
		"level": "Level: 4",
		"prerequisite": ["armor3"],
		"type": "upgrade"
	},
	"speed1": {
		"icon": ICON_PATH + "boots_4_green.png",
		"displayname": "Speed",
		"details": "Movement Speed Increased by 50% of base speed",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"speed2": {
		"icon": ICON_PATH + "boots_4_green.png",
		"displayname": "Speed",
		"details": "Movement Speed Increased by an additional 50% of base speed",
		"level": "Level: 2",
		"prerequisite": ["speed1"],
		"type": "upgrade"
	},
	"speed3": {
		"icon": ICON_PATH + "boots_4_green.png",
		"displayname": "Speed",
		"details": "Movement Speed Increased by an additional 50% of base speed",
		"level": "Level: 3",
		"prerequisite": ["speed2"],
		"type": "upgrade"
	},
	"speed4": {
		"icon": ICON_PATH + "boots_4_green.png",
		"displayname": "Speed",
		"details": "Movement Speed Increased an additional 50% of base speed",
		"level": "Level: 4",
		"prerequisite": ["speed3"],
		"type": "upgrade"
	},
	"grail1": {
		"icon": ICON_PATH + "grail.png",
		"displayname": "Grail",
		"details": "Damage is increased by an additional 10% of base damage",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"grail2": {
		"icon": ICON_PATH + "grail.png",
		"displayname": "Grail",
		"details": "Damage is increased by an additional 10% of base damage",
		"level": "Level: 2",
		"prerequisite": ["grail1"],
		"type": "upgrade"
	},
	"grail3": {
		"icon": ICON_PATH + "grail.png",
		"displayname": "Grail",
		"details": "Damage is increased by an additional 10% of base damage",
		"level": "Level: 3",
		"prerequisite": ["grail2"],
		"type": "upgrade"
	},
	"grail4": {
		"icon": ICON_PATH + "grail.png",
		"displayname": "Grail",
		"details": "Damage is increased by an additional 10% of base damage",
		"level": "Level: 4",
		"prerequisite": ["grail3"],
		"type": "upgrade"
	},
	"diamond1": {
		"icon": ICON_PATH + "Gem_blue.png",
		"displayname": "Diamond",
		"details": "Gain 5% more experience from gems",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"diamond2": {
		"icon": ICON_PATH + "Gem_blue.png",
		"displayname": "Diamond",
		"details": "Gain 5% more experience from gems",
		"level": "Level: 2",
		"prerequisite": ["diamond1"],
		"type": "upgrade"
	},
	"diamond3": {
		"icon": ICON_PATH + "Gem_blue.png",
		"displayname": "Diamond",
		"details": "Gain 5% more experience from gems",
		"level": "Level: 3",
		"prerequisite": ["diamond2"],
		"type": "upgrade"
	},
	"diamond4": {
		"icon": ICON_PATH + "Gem_blue.png",
		"displayname": "Diamond",
		"details": "Gain 5% more experience from gems",
		"level": "Level: 4",
		"prerequisite": ["diamond3"],
		"type": "upgrade"
	},
	"muscle1": {
		"icon": ICON_PATH + "muscle.png",
		"displayname": "Muscles",
		"details": "HP is increased by an additional 10% of base HP",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"muscle2": {
		"icon": ICON_PATH + "muscle.png",
		"displayname": "Muscles",
		"details": "HP is increased by an additional 10% of base HP",
		"level": "Level: 2",
		"prerequisite": ["muscle1"],
		"type": "upgrade"
	},
	"muscle3": {
		"icon": ICON_PATH + "muscle.png",
		"displayname": "Muscles",
		"details": "HP is increased by an additional 10% of base HP",
		"level": "Level: 3",
		"prerequisite": ["muscle2"],
		"type": "upgrade"
	},
	"muscle4": {
		"icon": ICON_PATH + "muscle.png",
		"displayname": "Muscles",
		"details": "HP is increased by an additional 10% of base HP",
		"level": "Level: 4",
		"prerequisite": ["muscle3"],
		"type": "upgrade"
	},
	"compass1": {
		"icon": ICON_PATH + "gem_magnet.png",
		"displayname": "Compass",
		"details": "Increase pickup range",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"compass2": {
		"icon": ICON_PATH + "gem_magnet.png",
		"displayname": "Compass",
		"details": "Increase pickup range",
		"level": "Level: 2",
		"prerequisite": ["compass1"],
		"type": "upgrade"
	},
	"compass3": {
		"icon": ICON_PATH + "gem_magnet.png",
		"displayname": "Compass",
		"details": "Increase pickup range",
		"level": "Level: 3",
		"prerequisite": ["compass2"],
		"type": "upgrade"
	},
	"compass4": {
		"icon": ICON_PATH + "gem_magnet.png",
		"displayname": "Compass",
		"details": "Increase pickup range",
		"level": "Level: 4",
		"prerequisite": ["compass3"],
		"type": "upgrade"
	},
	"bullet1": {
		"icon": ICON_PATH + "bullet.png",
		"displayname": "Bullet",
		"details": "Increase projectile speed by 10% of base speed",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"bullet2": {
		"icon": ICON_PATH + "bullet.png",
		"displayname": "Bullet",
		"details": "Increase projectile speed by 10% of base speed",
		"level": "Level: 2",
		"prerequisite": ["bullet1"],
		"type": "upgrade"
	},
	"bullet3": {
		"icon": ICON_PATH + "bullet.png",
		"displayname": "Bullet",
		"details": "Increase projectile speed by 10% of base speed",
		"level": "Level: 3",
		"prerequisite": ["bullet2"],
		"type": "upgrade"
	},
	"bullet4": {
		"icon": ICON_PATH + "bullet.png",
		"displayname": "Bullet",
		"details": "Increase projectile speed by 10% of base speed",
		"level": "Level: 4",
		"prerequisite": ["bullet3"],
		"type": "upgrade"
	},
	"tome1": {
		"icon": ICON_PATH + "thick_new.png",
		"displayname": "Tome",
		"details": "Increases the size of spells an additional 10% of their base size",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"tome2": {
		"icon": ICON_PATH + "thick_new.png",
		"displayname": "Tome",
		"details": "Increases the size of spells an additional 10% of their base size",
		"level": "Level: 2",
		"prerequisite": ["tome1"],
		"type": "upgrade"
	},
	"tome3": {
		"icon": ICON_PATH + "thick_new.png",
		"displayname": "Tome",
		"details": "Increases the size of spells an additional 10% of their base size",
		"level": "Level: 3",
		"prerequisite": ["tome2"],
		"type": "upgrade"
	},
	"tome4": {
		"icon": ICON_PATH + "thick_new.png",
		"displayname": "Tome",
		"details": "Increases the size of spells an additional 10% of their base size",
		"level": "Level: 4",
		"prerequisite": ["tome3"],
		"type": "upgrade"
	},
	"scroll1": {
		"icon": ICON_PATH + "scroll_old.png",
		"displayname": "Scroll",
		"details": "Decreases of the cooldown of spells by an additional 5% of their base time",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"scroll2": {
		"icon": ICON_PATH + "scroll_old.png",
		"displayname": "Scroll",
		"details": "Decreases of the cooldown of spells by an additional 5% of their base time",
		"level": "Level: 2",
		"prerequisite": ["scroll1"],
		"type": "upgrade"
	},
	"scroll3": {
		"icon": ICON_PATH + "scroll_old.png",
		"displayname": "Scroll",
		"details": "Decreases of the cooldown of spells by an additional 5% of their base time",
		"level": "Level: 3",
		"prerequisite": ["scroll2"],
		"type": "upgrade"
	},
	"scroll4": {
		"icon": ICON_PATH + "scroll_old.png",
		"displayname": "Scroll",
		"details": "Decreases of the cooldown of spells by an additional 5% of their base time",
		"level": "Level: 4",
		"prerequisite": ["scroll3"],
		"type": "upgrade"
	},
	"ring1": {
		"icon": ICON_PATH + "urand_mage.png",
		"displayname": "Ring",
		"details": "Your spells now spawn 1 more additional attack",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"ring2": {
		"icon": ICON_PATH + "urand_mage.png",
		"displayname": "Ring",
		"details": "Your spells now spawn an additional attack",
		"level": "Level: 2",
		"prerequisite": ["ring1"],
		"type": "upgrade"
	},
	"food": {
		"icon": ICON_PATH + "chunk.png",
		"displayname": "Food",
		"details": "Heals you for 20 health",
		"level": "N/A",
		"prerequisite": [],
		"type": "item"
	}
}
