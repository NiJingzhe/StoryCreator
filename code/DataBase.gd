extends Node
class_name DataBase

var sheet_list: Array = []

# Adds a new DataTable to the database
func add_table(table_name: String, attribute_names: Array, attribute_types: Array) -> bool:
	if has_node(table_name):
		return false
	var table = DataTable.new()
	table.name = table_name
	table.initialize(attribute_names, attribute_types)
	add_child(table)
	sheet_list.append(table)
	return true

# Deletes a DataTable from the database
func delete_table(table_name: String) -> bool:
	var table = get_node_or_null(table_name)
	if table == null:
		return false
	sheet_list.erase(table)
	table.queue_free()
	return true

# Queries a DataTable by name
func query_table(table_name: String) -> DataTable:
	return get_node_or_null(table_name)

# Modifies a DataTable by deleting the old one and adding a new one
func modify_table(table_name: String, new_attribute_names: Array, new_attribute_types: Array) -> bool:
	if delete_table(table_name):
		return add_table(table_name, new_attribute_names, new_attribute_types)
	return false

# Adds a new DataTable to the database by record
func add_table_by_record(table_name: String, record: Dictionary) -> bool:
	if has_node(table_name):
		return false
	
	var attribute_names = record.keys()
	var attribute_types = []
	for name_ in attribute_names:
		attribute_types.append(typeof(record[name_]))
	
	return add_table(table_name, attribute_names, attribute_types) and query_table(table_name).add_record(record)
