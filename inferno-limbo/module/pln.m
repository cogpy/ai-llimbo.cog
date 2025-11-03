PLN: module
{
	PATH: con "/dis/lib/pln.dis";

	# Probabilistic Logic Networks module
	
	# Inference rule types
	Rule: adt {
		name: string;
		premises: list of int;  # Atom IDs
		conclusion: int;        # Atom ID
		confidence: real;
	};

	# PLN Engine handle
	Engine: adt {
		atomspace: ref AtomSpace->Handle;
		rules: list of ref Rule;
	};

	# Core PLN operations
	init: fn(atomspace: ref AtomSpace->Handle): ref Engine;
	addrule: fn(e: ref Engine, rule: ref Rule);
	infer: fn(e: ref Engine, premises: list of int): list of ref AtomSpace->Atom;
	
	# Standard inference rules
	deduction: fn(a: ref AtomSpace->Atom, b: ref AtomSpace->Atom): ref AtomSpace->Atom;
	induction: fn(a: ref AtomSpace->Atom, b: ref AtomSpace->Atom): ref AtomSpace->Atom;
	abduction: fn(a: ref AtomSpace->Atom, b: ref AtomSpace->Atom): ref AtomSpace->Atom;
	
	# Revision and combination
	revision: fn(a: ref AtomSpace->Atom, b: ref AtomSpace->Atom): ref AtomSpace->TruthValue;
	conjunction: fn(a: ref AtomSpace->Atom, b: ref AtomSpace->Atom): ref AtomSpace->TruthValue;
};
