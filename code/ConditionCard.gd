extends MarginContainer
class_name ConditionCard

@export var data : Dictionary = {
	"switch_name" : "",
	"require_on" : true
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func init(switch_name, require_on):
	self.data["switch_name"] = switch_name
	self.data["require_on"] = require_on
	%ItemList.text = self.data["switch_name"]
	%CheckBox.button_pressed = self.data["require_on"]
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta : float) -> void:
	pass

func _on_delete_button_pressed() -> void:
	print("DELETE CONDITION : ", self.data)
	self.queue_free()

func _on_check_box_toggled(toggled_on) -> void:
	self.data["require_on"] = toggled_on
	if toggled_on:
		%CheckBox.set_text("Require on")
	else:
		%CheckBox.set_text("Require off")

func _on_item_list_pressed() -> void:
	var switch_table : DataTable = ProjectDataBase.query_table("SwitchTable")
	if switch_table != null:
		
		var item_count = %ItemList.item_count
		for i in range(0, item_count):
			%ItemList.remove_item(0)
		
		var switch_records = switch_table.get_rows()
		for switch in switch_records:
			%ItemList.add_item(switch["switch_name"])
			print("ADD ", switch["switch_name"], " to itemlist")

func _on_item_list_item_selected(index: int) -> void:
	var switch_name = %ItemList.get_item_text(index)
	print("CHOOSE ", switch_name, " AS CONDITION")
	self.data["switch_name"] = switch_name
	self.name = "condition_"+self.data["switch_name"]
