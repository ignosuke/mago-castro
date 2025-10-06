extends Node

@warning_ignore_start("unused_signal")

signal ATTEMPT_CAST(spell_name: String)
signal RECITING_SPELL
signal CAST_ON_COOLDOWN(spell_name: String)
signal TOGGLE_PENALTY(penalized: bool)

signal COOLDOWN_STARTED(spell_name: String, duration: float)
signal COOLDOWN_UPDATED(spell_name: String, time_left: float, progress: float)
signal COOLDOWN_ENDED(spell_name: String)

signal ATTACK_TOWER(damage: int)
signal TOWER_HEALTH_UPDATE(health_left: int)

signal HORDE_COMPLETED
