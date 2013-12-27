# Elerium\Commands #
Command line arguments parsing tool for JavaScript.

## Usage ##

Here is an example usage:
```
var commands = require('commands');

var configuration = commands.parse({
	parameter: {
		shortcut: 'short'
	}
}, ['--parameter', 'foo', '-short', 'bar']);
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
