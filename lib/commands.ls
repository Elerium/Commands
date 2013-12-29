_ = require 'prelude-ls'

get-parameters = (rules) ->
	_.Obj.keys rules

get-shortcuts = (rules) ->
	rules |> (_.Obj.filter (rule) ->
		rule.shortcut != undefined) |> (_.Obj.map (rule) ->
			rule.shortcut) |> _.Obj.values

get-defaults = (rules) ->
	rules |> (_.Obj.map (rule) ->
			rule.default)

is-parameter = (rules, parameter) -->
	parameter in get-parameters rules

is-shortcut = (rules, shortcut) -->
	shortcut in get-shortcuts rules

export parse = (rules, argv) -->
	parse-arguments rules, (is-parameter rules), (is-shortcut rules), argv

parse-arguments = (rules, is-parameter, is-shortcut, [parameter, argument, ...rest]) -->
	| parameter == undefined => get-defaults rules
	| otherwise =>
		parsed-parameter = (parse-parameter is-parameter, parameter) || (expand-shortcut rules, parse-shortcut is-shortcut, parameter) || throw new Error 'Parameter \'' + parameter + '\' does not exist.'
		parser = parse-arguments rules, is-parameter, is-shortcut

		if (parse-parameter is-parameter, argument) || (parse-shortcut is-shortcut, argument)
			parsed-arguments = parser [argument] ++ rest
			parsed-arguments[parsed-parameter] = parsed-arguments[parsed-parameter] || true
		else
			parsed-arguments = parser rest
			parsed-arguments[parsed-parameter] = if argument == undefined then (parsed-arguments[parsed-parameter] || true) else argument

		parsed-arguments

parameter-substr = (f, length, parameter) -->
	| typeof parameter != 'string' => undefined
	| parameter.length < length => undefined
	| otherwise =>
		parsed = parameter.substr(length)
		if f parsed then parsed

parse-parameter = (is-parameter, unparsed-parameter) -->
	parameter-substr is-parameter, 2, unparsed-parameter

parse-shortcut = (is-shortcut, unparsed-shortcut) -->
	parameter-substr is-shortcut, 1, unparsed-shortcut

expand-shortcut = (rules, shortcut) ->
	| shortcut == undefined => undefined
	| otherwise => rules |> _.Obj.obj-to-pairs |> (_.find ([parameter, rule]) ->
		rule.shortcut == shortcut) |> _.head

export help = (rules) ->
	max = 0
	texts = rules |> _.Obj.obj-to-pairs |> _.map ([parameter, rule]) ->
		parameters = '--' + parameter + (if rule.shortcut then ', -' + rule.shortcut else '')
		max := Math.max max, parameters.length
		[parameters, rule.description]

	texts |> _.foldl (acc, [parameters, description]) ->
		if description == undefined
			text = parameters
		else
			text = parameters + (_.Str.repeat (max - parameters.length + 1), ' ') + description

		acc + (if acc != '' then "\n" else '') + text
	, ''