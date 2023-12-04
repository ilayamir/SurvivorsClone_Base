extends Resource

class_name New_spawn_info

@export var time_start:int
@export var time_end:int
@export var enemy: Array[Resource]
@export var enemy_chance: Array[float]
@export var enemy_minimum:int
@export var enemy_spawn_rate:float
@export var instantanious: bool
@export var flock: bool
@export var chance:int
@export var boss:bool

var spawn_delay_counter = 0

