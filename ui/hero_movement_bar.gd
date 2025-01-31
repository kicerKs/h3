extends ProgressBar

func set_bar_maximum(val):
	self.max_value = val
	self.value = val

func set_bar_value(val):
	self.value = val
