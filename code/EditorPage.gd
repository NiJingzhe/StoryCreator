extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var window : Window = self.get_parent()
	window.get_window().min_size.x = 1100
	window.get_window().min_size.y = 400


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_plot_tab_button_pressed() -> void:
	%EditorTabContainer.current_tab = 0

func _on_data_base_tab_button_pressed() -> void:
	%EditorTabContainer.current_tab = 1

func _on_action_tab_button_pressed() -> void:
	%EditorTabContainer.current_tab = 2
