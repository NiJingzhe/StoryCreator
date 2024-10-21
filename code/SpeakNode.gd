extends PlotNode 
class_name SpeakNode

@export var summary : String = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	self.data["type"] = "speak"
	self.data["mode"] = "noloop"

	self.type = "plot"

	for require_on_switch in self.data["require_on"]:
		var condition_card : ConditionCard = preload("res://components/ConditionCard.tscn").instantiate()
		%ConditionContainer.add_child(condition_card)
		condition_card.init(require_on_switch, true)
		
	for require_off_switch in self.data["require_off"]:
		var condition_card : ConditionCard = preload("res://components/ConditionCard.tscn").instantiate()
		%ConditionContainer.add_child(condition_card)
		condition_card.init(require_off_switch, false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var condition_list : Array = %ConditionContainer.get_children()
	var exist_condition_list : Array = []
	for condition in condition_list:
		if condition.data["switch_name"] != "":
			exist_condition_list.append(condition.data["switch_name"])
			if condition.data["require_on"]:
				if condition.data["switch_name"] not in self.data["require_on"]:
					self.data["require_on"].append(condition.data["switch_name"])
				if condition.data["switch_name"] in self.data["require_off"]:
					var remove_id = self.data["require_off"].find(condition.data["switch_name"])
					self.data["require_off"].remove_at(remove_id)
			if not condition.data["require_on"]:
				if condition.data["switch_name"] not in self.data["require_off"]:
					self.data["require_off"].append(condition.data["switch_name"])
				if condition.data["switch_name"] in self.data["require_on"]:
					var remove_id = self.data["require_on"].find(condition.data["switch_name"])
					self.data["require_on"].remove_at(remove_id)
		
	
	for switch_name in self.data["require_on"]:
		if switch_name not in exist_condition_list:
			var remove_id = (self.data["require_on"] as Array).find(switch_name)
			self.data["require_on"].remove_at(remove_id)
			
	for switch_name in self.data["require_off"]:
		if switch_name not in exist_condition_list:
			var remove_id = (self.data["require_off"] as Array).find(switch_name)
			self.data["require_off"].remove_at(remove_id)
	
	self.tooltip_text = generate_tooltips()
			
	if self.data["is_head"]:
		self.set_slot_enabled_left(0, false)
	else:
		self.set_slot_enabled_left(0, true)
	
func generate_tooltips() -> String:
	var summary_ = self.summary
	var name_ = self.data["content"]["name"]
	var content_ = self.data["content"]["text"]
	var tooltip_str : String = "Summary:\n   "+summary_+"\n\nContent\n   "+ name_ + ":\n" + content_ + "\n\n"
	tooltip_str += "Require on:\n   "
	for switch_name in self.data["require_on"]:
		tooltip_str += switch_name + "\n   "
	
	tooltip_str += "\nRequire off:\n   "
	for switch_name in self.data["require_off"]:
		tooltip_str += switch_name + "\n   "
		
	return tooltip_str
	 
func _on_summary_box_text_changed():
	self.summary = %SummaryBox.text
	
func _on_head_check_toggled(toggled_on):
	self.data["is_head"] = toggled_on
	head_mode_changed.emit(self, toggled_on)

func _on_loop_mode_toggled(toggled_on):
	if toggled_on:
		self.data["mode"] = "loop"
	else:
		self.data["mode"] = "noloop"
		
func _on_condition_button_pressed():
	var condition_card : ConditionCard = preload("res://components/ConditionCard.tscn").instantiate()
	%ConditionContainer.add_child(condition_card)

func _on_option_button_item_selected(index):
	var role_name = %RoleSelection.get_item_text(index)
	var role_avator = %RoleSelection.get_item_metadata(index)
	
	self.data["content"]["name"] = role_name
	self.data["content"]["avator"] = role_avator

func _on_text_edit_text_changed():
	self.data["content"]["text"] = %ContentEditor.text
