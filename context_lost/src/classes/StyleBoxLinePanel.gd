extends Panel
class_name StyleBoxLinePanel

func _init() -> void:
	add_theme_stylebox_override('panel', StyleBoxLine.new())
