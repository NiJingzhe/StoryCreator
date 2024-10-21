extends GraphEdit
class_name PlotEditor

var filename : String = ""
var need_save : bool = false
var have_place_to_save : bool = false
var just_add_one : bool = false
var plot_node : PlotNode = null

var node_clipboard : Array = []


func init(filename_ : String, need_save_ : bool, have_place_to_save_ : bool):
	if filename_ == null or filename_ == "":
		self.filename = "未命名"
	else:
		self.filename = filename_	
	
	if need_save_:
		self.name = self.filename + " [ * ]"
	else:
		self.name = self.filename

	self.need_save = need_save_
	self.have_place_to_save = have_place_to_save_

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta : float) -> void:
	if just_add_one and plot_node != null:
		plot_node.set_position_offset((self.get_local_mouse_position() + self.scroll_offset) / self.zoom)
		
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			plot_node.set_position_offset((self.get_local_mouse_position() + self.scroll_offset) / self.zoom)
			just_add_one = false
			plot_node = null
		
	if Input.is_action_just_pressed("Mouse_RB_Click") and self.has_focus():
		%PopupMenu.visible = true
		%PopupMenu.position = self.get_local_mouse_position() + self.global_position
		
	if Input.is_action_just_pressed("Del"):
		delete_node()
	elif Input.is_action_just_pressed("ui_copy"):
		copy_node()
	elif Input.is_action_just_pressed("ui_paste") and not node_clipboard.is_empty():
		paste_node()
	elif Input.is_action_just_pressed("ui_cut"):
		copy_node()
		cut_node()
	elif Input.is_action_just_pressed("ui_text_select_all"):
		for child in self.get_children():
			if child is PlotNode and not (child as PlotNode).selected and (child as PlotNode).selectable:
				(child as PlotNode).selected = true
	elif Input.is_action_just_pressed("Save"):
		self.need_save = false
				
	if need_save:
		self.name = self.filename + " [ * ]"
	else:
		self.name = self.filename
	
				
func delete_node():
	for child in self.get_children():
		if child is PlotNode and (child as PlotNode).selected:
			child.queue_free()
	need_save = true
			
func copy_node():
	node_clipboard = []
	for child in self.get_children():
		if child is PlotNode and (child as PlotNode).selected:
			var node_copy = child.duplicate()
			node_clipboard.append(node_copy)
			
func paste_node():
	for node in node_clipboard:
		(node as PlotNode).position_offset.x += 150
		(node as PlotNode).position_offset.y += 150
		self.add_child(node)
		
	node_clipboard = []		
	need_save = true
	
func cut_node():
	for child in self.get_children():
		if child is PlotNode and (child as PlotNode).selected:
			child.queue_free()
	need_save = true


func _on_speak_button_pressed():
	var node : SpeakNode = preload("res://components/SpeakNode.tscn").instantiate()
	self.add_child(node)
	just_add_one = true
	plot_node = node
	need_save = true


func _on_narration_button_pressed():
	var node : NarrationNode = preload("res://components/NarrationNode.tscn").instantiate()
	self.add_child(node)
	just_add_one = true
	plot_node = node
	need_save = true

func _on_choice_button_pressed() -> void:
	var node : ChoiceNode = preload("res://components/ChoiceNode.tscn").instantiate()
	self.add_child(node)
	just_add_one = true
	plot_node = node
	need_save = true
	
func _on_popup_menu_index_pressed(index):
	# del
	if index == 0:
		delete_node()
	# copy			
	if index == 1 or index == 3:
		copy_node()
	# paste
	if index == 2 and not node_clipboard.is_empty():
		paste_node()	
	# cut
	if index == 3:
		cut_node()

func _on_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:

	var from_node_ = self.get_node(from_node as String)
	var to_node_ = self.get_node(to_node as String)

	var connect_result : bool = false
	if from_node_ is PlotNode and to_node_ is PlotNode:
		connect_result = (from_node_ as PlotNode).connect_to(to_node_ as PlotNode)

	if connect_result:
		self.connect_node(from_node, from_port, to_node, to_port)
		print(from_node_.get_data())
	else:
		var err_msg : String = "\nConnection between two Choice node is not allowed !"
		%ErrMsg.text = err_msg
		%PopupPanel.visible = true
		%PopupPanel.position = self.global_position + self.size / 2
		%PopupPanel.position -= Vector2i(%PopupPanel.size) / 2


	
func _on_disconnection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	self.disconnect_node(from_node, from_port, to_node, to_port)
	var from_node_ = self.get_node(from_node as String)
	var to_node_ = self.get_node(to_node as String)
	if from_node_ is PlotNode and to_node_ is PlotNode:
		(from_node_ as PlotNode).disconnect_to(to_node_ as PlotNode)

func _on_plot_node_head_mode_changed(changed_node : PlotNode, is_head : bool):
	if is_head:
		for node in changed_node.my_left:
			if node is PlotNode:
				self.disconnect_node(node.get_name(), 0, changed_node.get_name(), 0)
				node.disconnect_to(changed_node)


func _on_err_confirm_button_pressed() -> void:
	%PopupPanel.visible = false
