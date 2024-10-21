extends GraphNode
class_name PlotNode

signal head_mode_changed(changed_node : PlotNode, head_mode : bool)


# 导出变量，表示节点的数据结构，包含各种属性如 action、content、id 等
@export var data : Dictionary = {
	"action": [],          # 该节点的动作列表
	"content": {           # 该节点的内容，包括头像、名字、文本
		"avatar": "",
		"name" : "",
		"text": ""
	},
	"id": 0,               # 节点的唯一标识符
	"next": [],            # 下一个节点的列表，存储的是节点 ID
	"is_head" : false,     # 标识是否为头节点
	"require_off": [],     # 需要关闭的条件列表
	"require_on": [],      # 需要开启的条件列表
	"choices": [],         # 选择项的列表
	"type": "",            # 节点类型（旁白或对话或空等）
	"mode" : ""            # 节点模式（可否重复触发）
}

# 导出变量，表示选择项的数据结构
@export var choice_data : Dictionary = {
	"content" : "",        # 选择项的内容
	"next" : []            # 选择项的下一个节点列表
}

@export var type : String = ""  # 节点类型的字符串变量 choice / plot

var my_left : Array  = []        # 存储连接到该节点的左侧节点
var my_right : Array = []        # 存储连接到该节点的右侧节点

# 比较函数，根据节点 ID 排序
func sort_by_id(a : PlotNode, b : PlotNode) -> bool:
	return a.data["id"] < b.data["id"]

# 当节点首次进入场景树时调用
func _ready():

	# 连接自定义信号到父节点的处理函数
	self.head_mode_changed.connect(self.get_parent()._on_plot_node_head_mode_changed)

	# 获取父节点
	var parent : Node = self.get_parent()
	if parent == null:
		self.data["id"] = -32768  # 如果没有父节点，则设置 ID 为 -32768
	else:
		var child_count : int = parent.get_child_count()

		# 如果是唯一子节点，设置 ID 为 -32768
		if child_count <= 1:
			self.data["id"] = -32768
		else:
			# 获取所有子节点并筛选出 PlotNode 类型的节点
			var children_list : Array = parent.get_children()
			var siblings : Array = []
			for child in children_list:
				if child is PlotNode:
					siblings.append(child)
			# 按 ID 排序，生成新 ID 为最后一个节点 ID + 1
			siblings.sort_custom(sort_by_id)
			var last_id = siblings[len(siblings)-1].data["id"]
			self.data["id"] = last_id + 1	

# 获取节点数据，根据类型返回相应数据
func get_data() -> Dictionary:
	if self.type == "choice":
		return self.choice_data
	else:
		return self.data

# 设置节点数据，根据类型设置相应属性
func set_data(property : String, value : Variant) -> void:
	if self.type == "choice" and property in self.choice_data.keys():
		self.choice_data[property] = value
	elif property in self.data.keys():
		self.data[property] = value

# 连接到另一个节点，并返回布尔值指示是否成功
# 检查连接规则，确保 choice 和 action 类型的节点只能连接到 plot 类型的节点
func connect_to(to_node : PlotNode) -> bool:
	# 检查连接规则
	if (self.type == "choice" and to_node.type != "plot") or (to_node.type in "choice" and self.type != "plot"):
		return false

	self.my_right.append(to_node)  # 将目标节点添加到右侧节点列表
	to_node.my_left.append(self)   # 将当前节点添加到目标节点的左侧节点列表

	if to_node.type == "choice":
		self.data["choices"].append(to_node.get_data())  # 如果是选择类型，添加到选择项
	else:
		self.choice_data["next"].append(to_node.get_data()["id"])  # 否则，添加到下一个节点列表

	return true  # 连接成功

# 断开与另一个节点的连接，并从相应的列表中移除
func disconnect_to(to_node : PlotNode) -> void:
	var remove_id = self.my_right.find(to_node)  # 找到要移除的节点索引
	self.my_right.remove_at(remove_id)           # 从右侧节点列表中移除
	remove_id = to_node.my_left.find(self)       # 在目标节点的左侧节点列表中找到当前节点索引
	to_node.my_left.remove_at(remove_id)         # 从目标节点的左侧节点列表中移除

	if to_node.type == "choice":
		remove_id = self.data["choices"].find(to_node.get_data())  # 如果是选择类型，找到选择项索引
		self.data["choices"].remove_at(remove_id)                   # 从选择项列表中移除
	else:
		remove_id = self.data["next"].find(to_node.get_data()["id"])  # 否则，找到下一个节点索引
		self.data["next"].remove_at(remove_id)                       # 从下一个节点列表中移除
