# Elerium\Commands [![Build Status](https://travis-ci.org/Elerium/Commands.png)](https://travis-ci.org/Elerium/Commands) #
Command line parsing tool for Node.js.

## Usage ##

Here is an example usage:
```
var commands = require('commands');

var configuration = commands.parse({
	parameter: {
		shortcut: 's'
	}
}, ['--parameter', 'foo', '-s', 'bar']);
```

## Rules ##
Parameter prefix is '--' (two dashes) and rules names are written without it. Every rule should have default value and shortcut for parameter.

Default value is used if argument is empty or undefined.
```
var rules = {
	foo: {
		default: 'bar'
	}
}

commands.parse(rules, ['--foo']); // {foo: 'bar'}
```

Shortcut is only alias for parameter and is prefixed by '-' (dash).
```
var rules = {
	foo: {
		shortcut: 'f'
	}
}

commands.parse(rules, ['-f', 'bar']); // {foo: 'bar'}
```

## Help generating ##
You can also generate help message:
```
var rules = {
	foo: {
		shortcut: 'f',
		description: 'I\'m foo!'
	},
	foobar: {
		shortcut: 'b',
		description: 'I\'m foobar!'
	}
}

commands.help(rules);
```

Result will be:
```
--foo, -f    I'm foo!
--foobar, -b I'm foobar!
```