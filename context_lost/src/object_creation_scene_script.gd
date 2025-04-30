extends Control

@onready var grid_container    = find_child("GridContainer") as GridContainer
@onready var object_options	   = find_child("ObjectOptions") as OptionButton
@onready var auto_check_toggle = find_child("AutoCheck")   	 as CheckButton
@onready var add_button 	   = find_child("AddButton")   	 as Button
@onready var clear_button 	   = find_child("ClearButton") 	 as Button
@onready var debug_label  	   = find_child("DebugLabel")  	 as Label
@onready var amount_label 	   = find_child("AmountLabel") 	 as Label

var texture := preload("res://icon.svg")

var classes := [
	Control,
	Label,
	Button,
	TextureButton,
	ColorRect,
	TextureRect,
	Panel,
	StyleBoxEmptyPanel,
	StyleBoxLinePanel,
	StyleBoxTexturePanel
]
var curr_class = classes[0]

var amount_to_add := 2
var tween 		  : Tween


func _ready() -> void:
	object_options.item_selected.connect(_class_selected)
	add_button    .pressed		.connect(_add_objects)
	clear_button  .pressed		.connect(_clear_objects)
	amount_label.text = str(amount_to_add)
	for c in classes:
		if not c in [StyleBoxEmptyPanel, StyleBoxLinePanel, StyleBoxTexturePanel]:
			object_options.add_item(c.new().get_class())
		else:
			if c == StyleBoxEmptyPanel:
				object_options.add_item("StyleBoxEmptyPanel")
			elif c == StyleBoxLinePanel:
				object_options.add_item("StyleBoxLinePanel")
			elif c == StyleBoxTexturePanel:
				object_options.add_item("StyleBoxTexturePanel")


func _on_auto_check_toggled(toggled_on: bool) -> void:
	add_button	.disabled = toggled_on
	clear_button.disabled = toggled_on
	
	if not toggled_on and tween:
		tween.kill()
		tween = null
	if toggled_on:
		_clear_objects()
		tween = create_tween()
		tween.set_parallel(false)
		tween.set_loops()
		tween.tween_callback(_add_objects)	.set_delay(0.25)
		tween.tween_callback(_clear_objects).set_delay(0.25)


func _class_selected(index: int) -> void:
	curr_class = classes[index]


func _add_objects() -> void:
	var curr_amount = grid_container.get_child_count()
	for i in range(amount_to_add):
		var object  = curr_class.new()
		object.custom_minimum_size = Vector2(32, 32)
		match(object.get_class()):
			"Label":
				object.text = "label_" + str(i + curr_amount)
			"Button":
				object.text = "button_" + str(i + curr_amount)
			"TextureButton":
				object.texture_normal = texture
			"ColorRect":
				object.color = Color.WHITE
			"TextureRect":
				object.texture = texture
		grid_container.add_child(object)
	debug_label.text = "Objects in grid: " + str(grid_container.get_child_count())


func _clear_objects() -> void:
	for child in grid_container.get_children():
		child.queue_free()
		grid_container.remove_child(child)
	debug_label.text = "Objects in grid: " + str(grid_container.get_child_count())


func _on_reduce_button_pressed() -> void:
	amount_to_add 	  = clamp(amount_to_add / 2, 2, 4096)
	amount_label.text = str(amount_to_add)


func _on_increase_button_pressed() -> void:
	amount_to_add 	  = clamp(amount_to_add * 2, 2, 4096)
	amount_label.text = str(amount_to_add)
