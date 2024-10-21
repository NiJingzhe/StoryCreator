extends Control

var data : Dictionary = {
	"name": "Player",
	"score": 100,
	"health": 75.5,
	"is_alive": true
}

# 数据类型与UI组件的映射关系
var type_to_ui = {
	"String": LineEdit,
	"int": SpinBox,
	"float": SpinBox,
	"bool": CheckButton
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_ui_from_data()

# 根据data字典生成对应的UI组件
func create_ui_from_data() -> void:
	for key in data.keys():
		var value = data[key]
		var value_type = type_string(typeof(value))
		
		print("value: ", value, " type: ", value_type)
		
		var ui_component = type_to_ui[value_type].new()
		var margin_container : MarginContainer = MarginContainer.new()
		var hbox_container : HBoxContainer = HBoxContainer.new()
		var property_name : Label = Label.new()
		
		margin_container.set_anchors_preset(Control.PRESET_TOP_WIDE)
		var margin_value = 2
		margin_container.add_theme_constant_override("margin_top", margin_value)
		margin_container.add_theme_constant_override("margin_bottom", margin_value)
		
		hbox_container.set_anchors_preset(Control.PRESET_TOP_WIDE)
		hbox_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		
		property_name.text = key

		if ui_component != null:
			# 设置UI组件的默认值
			ui_component.name = key
			if value_type == "String":
				ui_component.text = str(value)
			elif value_type == "int":
				ui_component.value = int(value)
				(ui_component as SpinBox).step = 1
			elif value_type == "float":
				(ui_component as SpinBox).step = 0.01
				ui_component.value = float(value)
			elif value_type == "bool":
				(ui_component as CheckButton).button_pressed = bool(value)
			
			ui_component.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			# 将UI组件添加到场景树
			hbox_container.add_child(property_name)
			hbox_container.add_child(ui_component)
			margin_container.add_child(hbox_container)
			%VBoxContainer.add_child(margin_container)
