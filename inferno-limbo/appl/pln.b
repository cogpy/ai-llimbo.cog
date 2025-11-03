implement PLN;

include "sys.m";
	sys: Sys;
include "math.m";
	math: Math;

include "atomspace.m";
	atomspace: AtomSpace;
include "pln.m";

# Initialize PLN module
init(as: ref AtomSpace->Handle): ref Engine
{
	sys = load Sys Sys->PATH;
	math = load Math Math->PATH;
	atomspace = load AtomSpace AtomSpace->PATH;
	
	e := ref Engine;
	e.atomspace = as;
	e.rules = nil;
	
	return e;
}

# Add inference rule
addrule(e: ref Engine, rule: ref Rule)
{
	e.rules = rule :: e.rules;
}

# Perform inference
infer(e: ref Engine, premises: list of int): list of ref AtomSpace->Atom
{
	results: list of ref AtomSpace->Atom = nil;
	
	# Check each rule
	for (rl := e.rules; rl != nil; rl = tl rl) {
		rule := hd rl;
		
		# Check if premises match
		if (matchpremises(rule.premises, premises)) {
			atom := atomspace->getatom(e.atomspace, rule.conclusion);
			if (atom != nil)
				results = atom :: results;
		}
	}
	
	return results;
}

# Helper: Match premises
matchpremises(required: list of int, provided: list of int): int
{
	for (r := required; r != nil; r = tl r) {
		found := 0;
		rid := hd r;
		for (p := provided; p != nil; p = tl p) {
			if (rid == hd p) {
				found = 1;
				break;
			}
		}
		if (!found)
			return 0;
	}
	return 1;
}

# Deduction: A->B, B->C => A->C
deduction(a: ref AtomSpace->Atom, b: ref AtomSpace->Atom): ref AtomSpace->Atom
{
	# Calculate truth value using PLN formula
	sa := a.tv.strength;
	ca := a.tv.confidence;
	sb := b.tv.strength;
	cb := b.tv.confidence;
	
	# Deduction formula: s = sa * sb, c = ca * cb * sa
	s := sa * sb;
	c := ca * cb * sa;
	
	tv := atomspace->newtruthvalue(s, c);
	result := ref AtomSpace->Atom;
	result.id = -1;  # Temporary
	result.atype = 7;  # IMPLICATION_LINK
	result.name = "deduction_result";
	result.tv = tv;
	
	return result;
}

# Induction: A->B => B->A (with modified truth value)
induction(a: ref AtomSpace->Atom, b: ref AtomSpace->Atom): ref AtomSpace->Atom
{
	sa := a.tv.strength;
	ca := a.tv.confidence;
	
	# Induction formula (simplified)
	s := sa * 0.8;  # Reduced strength
	c := ca * 0.7;  # Reduced confidence
	
	tv := atomspace->newtruthvalue(s, c);
	result := ref AtomSpace->Atom;
	result.id = -1;
	result.atype = 7;  # IMPLICATION_LINK
	result.name = "induction_result";
	result.tv = tv;
	
	return result;
}

# Abduction: B->C, A->C => A->B
abduction(a: ref AtomSpace->Atom, b: ref AtomSpace->Atom): ref AtomSpace->Atom
{
	sa := a.tv.strength;
	ca := a.tv.confidence;
	sb := b.tv.strength;
	cb := b.tv.confidence;
	
	# Abduction formula
	s := (sa * sb) / (sa + sb - sa * sb + 0.0001);
	c := ca * cb * 0.6;
	
	tv := atomspace->newtruthvalue(s, c);
	result := ref AtomSpace->Atom;
	result.id = -1;
	result.atype = 7;  # IMPLICATION_LINK
	result.name = "abduction_result";
	result.tv = tv;
	
	return result;
}

# Revision: Combine two truth values
revision(a: ref AtomSpace->Atom, b: ref AtomSpace->Atom): ref AtomSpace->TruthValue
{
	sa := a.tv.strength;
	ca := a.tv.confidence;
	sb := b.tv.strength;
	cb := b.tv.confidence;
	
	# Revision formula
	w1 := ca / (ca + cb + 0.0001);
	w2 := cb / (ca + cb + 0.0001);
	s := w1 * sa + w2 * sb;
	c := ca + cb - ca * cb;
	
	return atomspace->newtruthvalue(s, c);
}

# Conjunction: AND operation on truth values
conjunction(a: ref AtomSpace->Atom, b: ref AtomSpace->Atom): ref AtomSpace->TruthValue
{
	sa := a.tv.strength;
	ca := a.tv.confidence;
	sb := b.tv.strength;
	cb := b.tv.confidence;
	
	# Conjunction formula
	s := sa * sb;
	c := ca * cb;
	
	return atomspace->newtruthvalue(s, c);
}

# Disjunction: OR operation on truth values
disjunction(a: ref AtomSpace->Atom, b: ref AtomSpace->Atom): ref AtomSpace->TruthValue
{
	sa := a.tv.strength;
	ca := a.tv.confidence;
	sb := b.tv.strength;
	cb := b.tv.confidence;
	
	# Disjunction formula: s = sa + sb - sa*sb
	s := sa + sb - sa * sb;
	c := ca * cb;
	
	return atomspace->newtruthvalue(s, c);
}

# Negation: NOT operation on truth value
negation(a: ref AtomSpace->Atom): ref AtomSpace->TruthValue
{
	sa := a.tv.strength;
	ca := a.tv.confidence;
	
	# Negation formula: s = 1 - sa
	s := 1.0 - sa;
	c := ca;
	
	return atomspace->newtruthvalue(s, c);
}

# Similarity: Measure of similarity between two atoms
similarity(a: ref AtomSpace->Atom, b: ref AtomSpace->Atom): ref AtomSpace->TruthValue
{
	sa := a.tv.strength;
	ca := a.tv.confidence;
	sb := b.tv.strength;
	cb := b.tv.confidence;
	
	# Similarity based on strength difference
	diff := sa - sb;
	if (diff < 0.0)
		diff = -diff;
	s := 1.0 - diff;
	c := (ca + cb) / 2.0;
	
	return atomspace->newtruthvalue(s, c);
}

# Implication: If A then B strength
implication(a: ref AtomSpace->Atom, b: ref AtomSpace->Atom): ref AtomSpace->TruthValue
{
	sa := a.tv.strength;
	ca := a.tv.confidence;
	sb := b.tv.strength;
	cb := b.tv.confidence;
	
	# Implication formula: strength weighted by antecedent
	s := sb / (sa + 0.0001);  # Avoid division by zero
	if (s > 1.0)
		s = 1.0;
	c := ca * cb * sa;
	
	return atomspace->newtruthvalue(s, c);
}
