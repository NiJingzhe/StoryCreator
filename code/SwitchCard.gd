extends MarginContainer
class_name SwitchCard

@export var data : Dictionary = {
	"switch_name" : "",
	"one_shot" : false	
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func init(switch_name, one_shot):
	self.data["switch_name"] = switch_name
	self.data["one_shot"] = one_shot
	%TextEdit.text = self.data["switch_name"]
	%CheckBox.button_pressed = self.data["one_shot"]

func _on_delete_button_pressed() -> void:
	print("delete self")
	self.queue_free()
	

func _on_text_edit_text_changed() -> void:
	self.data["switch_name"] = %TextEdit.text
	self.name = "condition_"+self.data["switch_name"]

func _on_check_box_toggled(toggled_on) -> void:
	self.data["one_shot"] = toggled_on
	if toggled_on:
		%CheckBox.set_text("One shot")
	else:
		%CheckBox.set_text("Toggle")
