OpenCog: module
{
	PATH: con "/dis/lib/opencog.dis";

	# Main OpenCog interface for Inferno
	
	# Cognitive system handle
	CogSystem: adt {
		atomspace: ref AtomSpace->Handle;
		plnengine: ref PLN->Engine;
		initialized: int;
	};

	# Atom type constants
	NODE: con 1;
	LINK: con 2;
	CONCEPT_NODE: con 3;
	PREDICATE_NODE: con 4;
	INHERITANCE_LINK: con 5;
	SIMILARITY_LINK: con 6;
	IMPLICATION_LINK: con 7;

	# Core system operations
	init: fn(): ref CogSystem;
	shutdown: fn(sys: ref CogSystem);
	
	# High-level cognitive operations
	addknowledge: fn(sys: ref CogSystem, concept: string, tv: ref AtomSpace->TruthValue): ref AtomSpace->Atom;
	query: fn(sys: ref CogSystem, pattern: string): list of ref AtomSpace->Atom;
	reason: fn(sys: ref CogSystem, premises: list of string): list of ref AtomSpace->Atom;
	
	# Learning operations
	learn: fn(sys: ref CogSystem, examples: list of (string, ref AtomSpace->TruthValue));
	adapt: fn(sys: ref CogSystem, feedback: real);
	
	# Pattern matching
	patternmatch: fn(sys: ref CogSystem, pattern: ref AtomSpace->Atom): list of ref AtomSpace->Atom;
};
