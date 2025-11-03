AtomTypes: module
{
	PATH: con "/dis/lib/atomtypes.dis";

	# Extended atom type constants for specialized cognitive operations
	
	# Basic types
	NODE: con 1;
	LINK: con 2;
	
	# Concept types
	CONCEPT_NODE: con 3;
	PREDICATE_NODE: con 4;
	SCHEMA_NODE: con 5;
	GROUNDED_SCHEMA_NODE: con 6;
	
	# Link types
	INHERITANCE_LINK: con 7;
	SIMILARITY_LINK: con 8;
	IMPLICATION_LINK: con 9;
	EQUIVALENCE_LINK: con 10;
	
	# Logical types
	AND_LINK: con 11;
	OR_LINK: con 12;
	NOT_LINK: con 13;
	
	# List types
	LIST_LINK: con 14;
	MEMBER_LINK: con 15;
	
	# Execution types
	EXECUTION_LINK: con 16;
	EVALUATION_LINK: con 17;
	
	# Context types
	CONTEXT_LINK: con 18;
	TEMPORAL_LINK: con 19;
	
	# Pattern types
	VARIABLE_NODE: con 20;
	PATTERN_LINK: con 21;
	BIND_LINK: con 22;
	
	# Truth value types
	SIMPLE_TRUTH_VALUE: con 1;
	COUNT_TRUTH_VALUE: con 2;
	INDEFINITE_TRUTH_VALUE: con 3;
	
	# Helper function to get type name
	typename: fn(atype: int): string;
	
	# Helper function to check if type is a node
	isnode: fn(atype: int): int;
	
	# Helper function to check if type is a link
	islink: fn(atype: int): int;
};
