require! 'assert'
require! '../lib/commands'

_it = it # Because LiveScript using 'it' as function parameter

rules1 =
	directory:
		shortcut: 'd',
		description: 'Directory'
	'-weird':
		shortcut: '-w',
		description: 'I don\'t really know...'

rules2 =
	port:
		shortcut: 'p',
		default: 8080
	empty: {}

describe '#parse', ->
	parser1 = commands.parse rules1
	parser2 = commands.parse rules2

	_it 'should parse parameter', ->
		assert.deepEqual directory: './lib', '-weird': void, parser1 ['--directory', './lib']
		assert.deepEqual directory: void, '-weird': 'yes', parser1 ['---weird', 'yes']

	_it 'should parse shortcuted parameter', ->
		assert.deepEqual directory: './lib', '-weird': void, parser1 ['-d', './lib']
		assert.deepEqual directory: void, '-weird': 'yes', parser1 ['--w', 'yes']

	_it 'should parse parameter with empty or null argument', ->
		assert.deepEqual directory: '', '-weird': void, parser1 ['--directory', '']
		assert.deepEqual directory: null, '-weird': void, parser1 ['--directory', null]
		assert.deepEqual port: '', empty: void, parser2 ['--port', '']
		assert.deepEqual port: null, empty: void, parser2 ['--port', null]

	_it 'should parse shortcuted parameter with empty or null argument', ->
		assert.deepEqual directory: '', '-weird': void, parser1 ['-d', '']
		assert.deepEqual directory: null, '-weird': void, parser1 ['-d', null]
		assert.deepEqual port: '', empty: void, parser2 ['-p', '']
		assert.deepEqual port: null, empty: void, parser2 ['-p', null]

	_it 'should parse switch parameter', ->
		assert.deepEqual directory: true, '-weird': void, parser1 ['--directory']
		assert.deepEqual directory: true, '-weird': true, parser1 ['--directory', '--w']
		assert.deepEqual directory: true, '-weird': true, parser1 ['--directory', undefined, '--w', undefined]

	_it 'should parse shortcuted switch parameter', ->
		assert.deepEqual directory: true, '-weird': void, parser1 ['-d']
		assert.deepEqual directory: true, '-weird': true, parser1 ['-d', '--w']
		assert.deepEqual directory: true, '-weird': true, parser1 ['-d', undefined, '--w', undefined]

	_it 'should parse parameter without argument with default value', ->
		assert.deepEqual port: 8080, empty: void, parser2 ['--port']
		assert.deepEqual port: 8080, empty: true, parser2 ['--port', '--empty']
		assert.deepEqual port: 8080, empty: true, parser2 ['--empty', '--port']
		assert.deepEqual port: 8080, empty: true, parser2 ['--empty', '--port', void]

	_it 'should parse shortcuted parameter without argument with default value', ->
		assert.deepEqual port: 8080, empty: void, parser2 ['-p']
		assert.deepEqual port: 8080, empty: true, parser2 ['-p', '--empty']
		assert.deepEqual port: 8080, empty: true, parser2 ['--empty', '-p']
		assert.deepEqual port: 8080, empty: true, parser2 ['--empty', '-p', void]

	_it 'should throw error on bad parameter prefix', ->
		assert.throws ->
			parser ['-directory', './lib']

	_it 'should throw error on bad shortcuted parameter prefix', ->
		assert.throws ->
			parser ['--d', './lib']

	_it 'should throw error on undefined parameter', ->
		assert.throws ->
			parser ['value']

describe '#help', ->
	_it 'should generate help', ->
		assert.equal "--directory, -d Directory\n---weird, --w   I don't really know...", commands.help rules1
		assert.equal "--port, -p\n--empty", commands.help rules2