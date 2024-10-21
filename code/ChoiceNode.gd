extends PlotNode
class_name ChoiceNode 

func _ready() -> void:
	super._ready()
	self.type = "choice"
	
func _on_text_edit_text_changed() -> void:
	self.set_data("content", %TextEdit.text)
