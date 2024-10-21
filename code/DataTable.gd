extends Node
class_name DataTable

var attributes: Dictionary = {}
var records: Array = []
var initialized: bool = false

# Initializes the DataTable with attribute names and types
func initialize(attribute_names: Array, attribute_types: Array) -> void:
	for i in range(attribute_names.size()):
		attributes[attribute_names[i]] = attribute_types[i]
	initialized = true

# Adds a record to the table
func add_record(record: Dictionary) -> bool:
	if not initialized:
		# Automatically initialize with the first record
		var attribute_names = record.keys()
		var attribute_types = []
		for name_ in attribute_names:
			attribute_types.append(typeof(record[name_]))
		initialize(attribute_names, attribute_types)
	
	# Ensure the record matches the table structure
	for key in attributes.keys():
		if not record.has(key) or typeof(record[key]) != attributes[key]:
			return false
	
	records.append(record)
	return true

# Deletes a record from the table
func delete_record(record_index: int) -> bool:
	if record_index >= 0 and record_index < records.size():
		records.remove_at(record_index)
		return true
	return false

# Queries a record by index
func query_record(record_index: int) -> Dictionary:
	if record_index >= 0 and record_index < records.size():
		return records[record_index]
	return {}

# Modifies a record in the table
func modify_record(record_index: int, new_record: Dictionary) -> bool:
	if record_index >= 0 and record_index < records.size():
		for key in attributes.keys():
			if not new_record.has(key) or typeof(new_record[key]) != attributes[key]:
				return false
		records[record_index] = new_record
		return true
	return false

# Finds records by a specified field and value and returns their indices (IDs)
func query_records_by_field(field_name: String, field_value: Variant) -> Array:
	var result: Array = []
	if not attributes.has(field_name):
		return result
	
	for i in range(records.size()):
		var record = records[i]
		if record.has(field_name) and record[field_name] == field_value:
			result.append(i)  # Store the index (ID) of the matching record
	
	return result
	
# Gets all rows (records) in the table
func get_rows() -> Array:
	return records.duplicate()  # Returns a copy of the records array

# Gets all columns (attribute names) in the table
func get_cols() -> Array:
	return attributes.keys()  # Returns an array of attribute names
