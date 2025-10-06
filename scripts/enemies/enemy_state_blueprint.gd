class_name EnemyStateBlueprint extends State

var enemy:Enemy:
	set(value):
		suscribed_node = value
	get:
		return suscribed_node
