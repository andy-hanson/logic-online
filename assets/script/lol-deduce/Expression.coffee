{ abstract, check, fail, type, typeEach, typeExist } = require './help/✔'
{ last } = require './help/list'
{ read } = require './help/meta'
{ indented } = require './help/str'
T = require './compile/Token'
Pos = require './Pos'

###
Any compiled output.
###
class Expression
	# @noDoc
	inspect: ->
		@toString()

	#toString: ->
	#	"#{@show()} #{@posStr()}"

	###
	Every `Expression` needs a `Pos`.
	###
	pos: ->
		abstract()

	posStr: ->
		"{#{@pos()}}"

###
A logic expression.
###
class Logic extends Expression
	equals: (oth) ->
		abstract()

#class Atom extends Logic
#	toDeclare: ->
#		abstract()

###
An Logic consisting of a single thing.
###
class AtomDeclare extends Expression
	###
	@param @_pos [Pos]
	@param @_name [String]
	###
	constructor: (@_pos, @_name) ->
		type @_name, String
		Object.freeze @

	read @, 'pos', 'name'

	toDeclare: ->
		@

	equals: (oth) ->
		if oth instanceof AtomReference
			@equals oth.referenced()
		else
			if oth instanceof AtomDeclare and @name() == oth.name()
				check @ == oth
			@ == oth

	# @noDoc
	toString: ->
		@name()

class AtomReference extends Logic
	constructor: (@_pos, @_referenced) ->
		type @_pos, Pos, @_referenced, AtomDeclare

	read @, 'pos', 'referenced'

	toDeclare: ->
		@referenced()

	name: ->
		@referenced().name()

	toString: ->
		@name()

	equals: (oth) ->
		@referenced().equals oth

###
An Logic calling one on another.
###
class Fun extends Logic
	###
	@param @_pos [Pos]
	@param @_caller [Logic]
	@param @_subs [Array<Logic>]
	###
	constructor: (@_pos, @_caller, @_subs) ->
		type @_pos, Pos
		type @_caller, Logic
		typeEach @_subs, Logic
		Object.freeze @

	read @, 'pos', 'caller', 'subs'

	arity: ->
		@subs().length

	toString: ->
		"(#{@caller()} #{@subs().join ' '})"

	equals: (oth) ->
		oth instanceof Fun and (@caller().equals oth.caller()) and do =>
			if @subs().length == 2
				a = @subs()
				b = oth.subs()
				(a[0].equals b[0]) and (a[1].equals b[1]) or \
					(a[0].equals b[1]) and (a[1].equals b[0])
			else
				check @subs().length == 1
				@subs()[0].equals oth.subs()[0]


class ProofPart extends Expression
	toExpression: ->
		abstract()

class Rule extends ProofPart
	constructor: (@_pos, @_name, @_newAtoms, @_premises, @_proof) ->
		type @_name, String, @_pos, Pos
		typeEach @_newAtoms, AtomDeclare, @_premises, Logic, @_proof, ProofPart

	read @, 'pos', 'name', 'newAtoms', 'premises', 'proof'

	conclusion: ->
		(last @proof()).toExpression()

	arity: ->
		@premises().length

	toExpression: ->
		if @newAtoms().length == 0
			check @arity() == 1, "',' in supposition is TODO"
			imp = new AtomReference @pos(), AutoDeclare.Implies
			new Fun @pos(), imp, [ @premises()[0], @conclusion() ]
		else
			fail "Rule to for-all is TODO"

	toString: ->
		name = @name()
		nas = @newAtoms().join ', '
		ps = @premises().join ', '
		proof = @proof().join '\n\t'
		"rule #{name} #{nas}: #{ps} ⇒ #{@posStr()}\n\t#{proof}"

class Line extends ProofPart
	constructor: (@_pos, @_name, @_expression, @_justification) ->
		type @_pos, Pos, @_expression, Logic
		typeExist @_name, String, @_justification, Justification

	read @, 'pos', 'name', 'expression', 'justification'

	isJustified: ->
		@justification()?

	toExpression: ->
		@expression()

	toString: ->
		name = if @name()? then "#{@name()}: " else ''
		just = if @justification()? then " |#{@justification()}" else ''
		"#{name}#{@expression().show()}#{just}"

class Justification extends Expression
	constructor: (@_pos, @_rule, @_justifiers) ->
		type @_pos, Pos, @_rule, Rule
		typeEach @_justifiers, ProofPart

	read @, 'pos', 'rule', 'justifiers'

	arity: ->
		@justifiers().length

	toString: ->
		js = @justifiers().map (j) -> j.name()
		"#{@rule().name()} #{js.join ', '}"

AutoDeclare =
	Implies: new AtomDeclare Pos.start(), '→'
	And: new AtomDeclare Pos.start(), '∧'

AutoDeclares = [ AutoDeclare.Implies, AutoDeclare.And ]

module.exports =
	AutoDeclares: AutoDeclares

	Expression: Expression

	Logic: Logic
	AtomDeclare: AtomDeclare
	AtomReference: AtomReference
	Fun: Fun

	# Block: Block
	ProofPart: ProofPart
	Rule: Rule
	Line: Line
	Justification: Justification
