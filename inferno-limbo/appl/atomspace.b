implement AtomSpace;

include "sys.m";
	sys: Sys;
include "draw.m";

include "atomspace.m";

# Global constants
INITIAL_CAPACITY: con 1000;
HASH_SIZE: con 256;  # Size of hash tables for indexing

# Initialize AtomSpace module
init(): ref Handle
{
	sys = load Sys Sys->PATH;
	
	h := ref Handle;
	h.atoms = nil;
	h.nextid = 1;
	h.indexsize = HASH_SIZE;
	
	# Initialize hash tables
	h.idindex = array[HASH_SIZE] of ref HashBucket;
	h.nameindex = array[HASH_SIZE] of ref HashBucket;
	h.typeindex = array[HASH_SIZE] of ref HashBucket;
	
	return h;
}

# Hash an integer value
hashint(val: int, size: int): int
{
	return val % size;
}

# Hash a string value using simple algorithm
hashstring(str: string, size: int): int
{
	hash := 0;
	for (i := 0; i < len str; i++)
		hash = (hash * 31 + str[i]) % size;
	return hash;
}

# Add entry to hash table
addhash(table: array of ref HashBucket, key: int, atom: ref Atom)
{
	bucket := ref HashBucket;
	bucket.id = key;
	bucket.atom = atom;
	bucket.next = table[key];
	table[key] = bucket;
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
	
	# Add to hash indexes for fast lookup
	idhash := hashint(atom.id, h.indexsize);
	addhash(h.idindex, idhash, atom);
	
	namehash := hashstring(name, h.indexsize);
	addhash(h.nameindex, namehash, atom);
	
	typehash := hashint(atype, h.indexsize);
	addhash(h.typeindex, typehash, atom);
	
	return atom;
}

# Get atom by ID using hash index
getatom(h: ref Handle, id: int): ref Atom
{
	hash := hashint(id, h.indexsize);
	for (bucket := h.idindex[hash]; bucket != nil; bucket = bucket.next) {
		if (bucket.atom.id == id)
			return bucket.atom;
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

# Find atoms by type using hash index
findatomsbytype(h: ref Handle, atype: int): list of ref Atom
{
	result: list of ref Atom = nil;
	hash := hashint(atype, h.indexsize);
	for (bucket := h.typeindex[hash]; bucket != nil; bucket = bucket.next) {
		if (bucket.atom.atype == atype)
			result = bucket.atom :: result;
	}
	return result;
}

# Find atoms by name using hash index
findatomsbyname(h: ref Handle, name: string): list of ref Atom
{
	result: list of ref Atom = nil;
	hash := hashstring(name, h.indexsize);
	for (bucket := h.nameindex[hash]; bucket != nil; bucket = bucket.next) {
		if (bucket.atom.name == name)
			result = bucket.atom :: result;
	}
	return result;
}
