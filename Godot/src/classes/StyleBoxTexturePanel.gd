extends Panel
class_name StyleBoxTexturePanel

const texture := preload("res://icon.svg")


func _init() -> void:
	var sb 	   = StyleBoxTexture.new()
	sb.texture = texture
	add_theme_stylebox_override('panel', sb)
