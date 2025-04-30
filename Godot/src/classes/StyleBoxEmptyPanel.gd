extends Panel
class_name StyleBoxEmptyPanel

func _init() -> void:
	add_theme_stylebox_override('panel', StyleBoxEmpty.new())
