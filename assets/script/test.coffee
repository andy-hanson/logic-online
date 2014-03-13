proof = '''
\ This
a
	a

\ This

'''

lolDeduce = require './lol-deduce'

# ⊤⊥
# ∨∧¬→↔⊕
# ∀∃
# ⇒⊢↴



console.log lolDeduce.checkLogic proof

