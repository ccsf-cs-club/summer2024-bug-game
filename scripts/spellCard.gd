extends Card
class_name SpellCard

@export_multiline var effectString: String = ""
@export var spellScript: Script
# find a way to export a reference to some other code
# or a function or something I can call to make
# some effect

func run_card_effect():
	print('Running spell script')
	
	# Create an instance of the script and call run_effect on it
	# Instance should get automatically removed once all references to it are removed
	# AKA once the spell get's queue_freed
	var script_instance = spellScript.new()
	script_instance.run_effect()
