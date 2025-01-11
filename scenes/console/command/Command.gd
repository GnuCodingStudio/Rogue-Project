@icon("res://scenes/console/command/command.png")
class_name Command
extends Node


@export var target: Node
@export var function: String
@export_multiline  var help: String
@export var parameters: Array[String]


### BUILT-IN ###


func _ready() -> void:
	assert(name == name.to_lower(), "Command name \"%s\" must be lower cased" % name)
	assert(target != null, "A command must target a node")
	assert(!function.is_empty(), "A command must refer to a function")
	assert(target.has_method(function), "Function \"%s\" doesn't exist on the target" % function)
	_assert_paramters(parameters)


### LOGIC ###


func _assert_paramters(parameters: Array[String]) -> void:
	for parameter in parameters:
		var param_split = parameter.split(":")
		var param_name = param_split[0]
		var param_type = param_split[1]

		assert(
			not param_name.is_empty(),
			"A parameter of \"%s\" has no name" % name
		)

		assert(
			param_type in ["string", "int", "float"],
			"Paramter \"%s.%s\" has unknown type \"%s\", expected are [string, int, float]" % [name, param_name, param_type]
		)

		if param_split.size() >= 3:
			_assert_parameter_default(param_name, param_type, param_split[2])


func _assert_parameter_default(param_name: String, param_type: String, param_default: String):
	match(param_type):
		"float": assert(
			param_default.is_valid_float(),
			"Default value \"%s\" of parameter \"%s.%s\" is not a float" % [param_default, name, param_name]
		)
		"int": assert(
			param_default.is_valid_int(),
			"Default value \"%s\" of parameter \"%s.%s\" is not an integer" % [param_default, name, param_name]
		)
