{ check, fail, type, typeEach } = require '../help/✔'
{ cCheck } = require '../c✔'
{ zipped } = require '../help/list'
StringMap = require '../help/StringMap'
E = require '../Expression'

###
Any errors have their message prepended by the result of `annotate`.
###
annotateErrors = (mayThrow, annotate) ->
	type mayThrow, Function, annotate, Function

	try
		mayThrow()
	catch error
		error.message = "#{annotate()}: #{error.message}"
		throw error


###
@param proof [Array<ProofPart>]
@return [Array<Line>]
  If `expression` is valid, returns its premises (unjustified lines).
  Otherwise, throws an error about the first invalid statement.
###
module.exports = checkLogic = (proof) ->
	typeEach proof, E.ProofPart

	premises = []

	proof.forEach (subExpr) ->
		switch subExpr.constructor
			when E.Rule
				annotateErrors ->
					premises.push (checkLogic subExpr.proof())...
				, ->
					"In rule #{subExpr.name()}"

			when E.Line
				if subExpr.isJustified()
					checkJustified subExpr
				else
					premises.push subExpr

			else
				fail() # ProofPart is Rule or Line.

	premises


###
Checks that a line's justification validly uses a rule.
###
checkJustified = (line) ->
	type line, E.Line

	justify = line.justification()
	rule = justify.rule()

	annotateErrors ->
		cCheck rule.arity() == justify.arity(), justify.pos(), ->
			"Rule takes #{rule.arity()} premises; you provided #{justify.arity()}."

		assignment = new StringMap
		# Add an empty assignment for each new atom of the rule.
		rule.newAtoms().forEach (atom) ->
			assignment.add atom.name(), null

		zipped rule.premises(), justify.justifiers(), (premise, justifier) ->
			patternMatch premise, justifier.toExpression(), assignment

		patternMatch rule.conclusion(), line.expression(), assignment

		# We should have assigned to everything.
		check rule.newAtoms().every (atom) -> (assignment.get atom.name())?

	, -> "Using #{rule.name()}"


###
Assigns sub-expressions of `matched` to the new variables of `pattern`.
New variables are those given slots in `assignment`.

Examples:
	in:
		pattern: `a ∧ b`
		matched: `(c ^ d) ^ b`
		assignment: `{ a: null }`
	out:
		assignment: `{ a: c ^ d }`
		`a` is a new atom and can be any pattern.
		`b` refers to an external declaration and must be matched exactly.

	in:
		pattern: `a ∧ b`
		matched: `x ∧ y`
		assignment: `{ a: null }`
	out:
		Fails. `y` does not match up with `b`.
		`a` is a new atom; `b` refers to something outside the rule
		and must be matched exactly.

	in:
		pattern = `a ∧ a`
		matched = `x ∧ y`
		assignment: `{ a: null }`
	out:
		Fails. There can only be one assignment to `a`.

@param pattern [E.Logic]
  Part of the rule to be matched against.
  Rule's new atoms may be matched by any expression;
  atoms that refer outside of the rule must be matched exactly.
@param matched [E.Logic]
  Expression used in a justification that the user claims will match the rule.
@param assignment [StringMap]
  Current assignment whose keys are the rule's new atoms.
###
patternMatch = (pattern, matched, assignment) ->
	type pattern, E.Logic, matched, E.Logic, assignment, StringMap

	matchNeeds = (cond) ->
		cCheck cond, matched.pos(), ->
			"Can't match #{pattern} with #{matched}"

	switch pattern.constructor
		when E.Fun
			matchNeeds matched instanceof E.Fun and
				pattern.arity() == matched.arity()

			patternMatch pattern.caller(), matched.caller(), assignment
			zipped pattern.subs(), matched.subs(), (subPattern, subMatched) ->
				patternMatch subPattern, subMatched, assignment

		when E.AtomReference
			# Two AtomReferences are equal if they refer to the same AtomDeclare.

			name = pattern.name()
			if assignment.has name # If it's one of the rule's new atoms:
				got = assignment.get name
				if got == null
					# It hasn't been assigned yet; assign it now.
					assignment.add name, matched
				else
					cCheck (matched.equals got), matched.pos(), ->
						"Conflicting assignments to #{name}: " +
						"#{matched} and #{assignment.get name}"
			else
				matchNeeds pattern.equals matched

		else
			fail() # Logic is Fun or AtomReference.
