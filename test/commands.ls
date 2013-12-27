require! 'assert'
require! '../lib/commands'

_it = it # Because LiveScript using 'it' as function parameter

describe '#parse-arguments', ->
	rules =
		directory:
			shortcut: 'd',
			default: './vendor'
		port:
			shortcut: 'p'
		'-weird':
			shortcut: '-w'

	parser = commands.parse rules

	_it 'should parse parameter', ->
		assert.deepEqual directory: './lib', parser ['--directory', './lib']
		assert.deepEqual '-weird': 'yes', parser ['---weird', 'yes']

	_it 'should parse shortcuted parameter', ->
		assert.deepEqual directory: './lib', parser ['-d', './lib']
		assert.deepEqual '-weird': 'yes', parser ['--w', 'yes']

	_it 'should parse parameter without argument', ->
		assert.deepEqual port: void, parser ['--port']
		assert.deepEqual port: void, parser ['--port', '']
		assert.deepEqual port: void, parser ['--port', undefined]
		assert.deepEqual port: void, parser ['--port', null]
		assert.deepEqual port: void '-weird': void, parser ['--port', '---weird']

	_it 'should parse shortcuted parameter without argument', ->
		assert.deepEqual port: void, parser ['-p']
		assert.deepEqual port: void, parser ['--port', '']
		assert.deepEqual port: void, parser ['-p', undefined]
		assert.deepEqual port: void, parser ['-p', null]
		assert.deepEqual port: void '-weird': void, parser ['-p', '--w']

	_it 'should parse parameter without argument with default value', ->
		assert.deepEqual directory: './vendor', parser ['--directory']
		assert.deepEqual directory: './vendor', parser ['--directory', '']
		assert.deepEqual directory: './vendor' '-weird': void, parser ['--directory', '---weird']

	_it 'should parse shortcuted parameter without argument with default value', ->
		assert.deepEqual directory: './vendor', parser ['-d']
		assert.deepEqual directory: './vendor', parser ['-d', '']
		assert.deepEqual directory: './vendor' '-weird': void, parser ['-d', '--w']

	_it 'should throw error on bad parameter prefix', ->
		assert.throws ->
			parser ['-directory', './lib']

	_it 'should throw error on bad shortcuted parameter prefix', ->
		assert.throws ->
			parser ['--d', './lib']

	_it 'should throw error on undefined parameter', ->
		assert.throws ->
			parser ['value']