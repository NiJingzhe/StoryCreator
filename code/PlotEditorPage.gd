extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var editor : PlotEditor = preload("res://components/PlotEditor.tscn").instantiate()
	%EditorTab.add_child(editor)
	editor.init("Untitled_1", true, false)
	editor.grab_focus()


func _process(_delta: float) -> void:

	var new_switch_list : Array = []
	for child in %SwitchContainer.get_children():
		if child is SwitchCard:
			new_switch_list.append((child as SwitchCard).data)

	
	var switch_table : DataTable = ProjectDataBase.query_table("SwitchTable")
	if switch_table != null and not new_switch_list.is_empty():
		for switch in new_switch_list:
			var exist = false
			for row in switch_table.get_rows():
				if row["switch_name"] == switch["switch_name"]:
					exist = true
					break
			if not exist:
				switch_table.add_record(switch)
				
		for switch in switch_table.get_rows():
			if switch not in new_switch_list:
				var index = switch_table.query_records_by_field("switch_name", switch["switch_name"])[0]
				switch_table.delete_record(index)
	
	elif not new_switch_list.is_empty():
		ProjectDataBase.add_table_by_record("SwitchTable", new_switch_list[0])
			
			

func _on_add_switch_pressed() -> void:
	var new_switch : SwitchCard = preload("res://components/SwitchCard.tscn").instantiate()
	%SwitchContainer.add_child(new_switch)

	var table : DataTable = ProjectDataBase.query_table("SwitchTable")
	if table != null:
		print(table.get_rows())

	print("NEW SWITCH ADDED : ", new_switch.data)

	
