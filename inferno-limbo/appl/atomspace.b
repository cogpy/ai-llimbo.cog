implement AtomSpace;

include "sys.m";
	sys: Sys;
include "draw.m";

include "atomspace.m";

# Global constants
INITIAL_CAPACITY: con 1000;

# Initialize AtomSpace module
init(): ref Handle
{
	sys = load Sys Sys->PATH;
	
	h := ref Handle;
	h.atoms = nil;
	h.nextid = 1;
	
	return h;
}

# Add an atom to the AtomSpace
addatom(h: ref Handle, atype: int, name: string, tv: ref TruthValue): ref Atom
{
	atom := ref Atom;
	atom.id = h.nextid++;
	atom.atype = atype;
	atom.name = name;
	atom.tv = tv;
	
	# Add to list
	h.atoms = atom :: h.atoms;
	
	return atom;
}

# Get atom by ID
getatom(h: ref Handle, id: int): ref Atom
{
	for (l := h.atoms; l != nil; l = tl l) {
		atom := hd l;
		if (atom.id == id)
			return atom;
	}
	return nil;
}

# Remove atom from AtomSpace
removeatom(h: ref Handle, id: int): int
{
	prev: list of ref Atom = nil;
	for (l := h.atoms; l != nil; l = tl l) {
		atom := hd l;
		if (atom.id == id) {
			# Remove from list
			if (prev == nil)
				h.atoms = tl l;
			else
				prev = tl l;
			return 1;
		}
		prev = l;
	}
	return 0;
}

# Get all atoms
getatoms(h: ref Handle): list of ref Atom
{
	return h.atoms;
}

# Create new truth value
newtruthvalue(strength: real, confidence: real): ref TruthValue
{
	tv := ref TruthValue;
	tv.strength = strength;
	tv.confidence = confidence;
	return tv;
}

# Update truth value of an atom
updatetruthvalue(atom: ref Atom, tv: ref TruthValue)
{
	atom.tv = tv;
}

# Find atoms by type
findatomsbytype(h: ref Handle, atype: int): list of ref Atom
{
	result: list of ref Atom = nil;
	for (l := h.atoms; l != nil; l = tl l) {
		atom := hd l;
		if (atom.atype == atype)
			result = atom :: result;
	}
	return result;
}

# Find atoms by name
findatomsbyname(h: ref Handle, name: string): list of ref Atom
{
	result: list of ref Atom = nil;
	for (l := h.atoms; l != nil; l = tl l) {
		atom := hd l;
		if (atom.name == name)
			result = atom :: result;
	}
	return result;
}
