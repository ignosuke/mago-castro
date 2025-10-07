class_name State extends Node

@onready var suscribed_node: Node = self.owner

var state_machine: FiniteStateMachine

#region INHERITED

func _enter() -> void:
	# DEBUG PRINT
	# print(suscribed_node.name, " - ", self.name)
	pass

func _exit() -> void:
	pass

#endregion
