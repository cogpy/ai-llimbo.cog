implement AtomTypes;

include "sys.m";
	sys: Sys;

include "atomtypes.m";

# Get the name of an atom type
typename(atype: int): string
{
	case atype {
	1 => return "NODE";
	2 => return "LINK";
	3 => return "CONCEPT_NODE";
	4 => return "PREDICATE_NODE";
	5 => return "SCHEMA_NODE";
	6 => return "GROUNDED_SCHEMA_NODE";
	7 => return "INHERITANCE_LINK";
	8 => return "SIMILARITY_LINK";
	9 => return "IMPLICATION_LINK";
	10 => return "EQUIVALENCE_LINK";
	11 => return "AND_LINK";
	12 => return "OR_LINK";
	13 => return "NOT_LINK";
	14 => return "LIST_LINK";
	15 => return "MEMBER_LINK";
	16 => return "EXECUTION_LINK";
	17 => return "EVALUATION_LINK";
	18 => return "CONTEXT_LINK";
	19 => return "TEMPORAL_LINK";
	20 => return "VARIABLE_NODE";
	21 => return "PATTERN_LINK";
	22 => return "BIND_LINK";
	* => return "UNKNOWN";
	}
}

# Check if an atom type is a node
isnode(atype: int): int
{
	if (atype >= 1 && atype <= 6)
		return 1;
	if (atype == 20)  # VARIABLE_NODE
		return 1;
	return 0;
}

# Check if an atom type is a link
islink(atype: int): int
{
	if (atype >= 7 && atype <= 19)
		return 1;
	if (atype >= 21 && atype <= 22)  # Pattern and bind links
		return 1;
	return 0;
}
