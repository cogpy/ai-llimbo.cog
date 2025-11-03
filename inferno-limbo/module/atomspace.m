AtomSpace: module
{
	PATH: con "/dis/lib/atomspace.dis";

	# Atom types
	Atom: adt {
		id: int;
		atype: int;
		name: string;
		tv: ref TruthValue;
	};

	# Truth value representation
	TruthValue: adt {
		strength: real;
		confidence: real;
	};

	# Hash bucket for indexed lookups
	HashBucket: adt {
		id: int;
		atom: ref Atom;
		next: ref HashBucket;
	};

	# AtomSpace handle with hash indexing
	Handle: adt {
		atoms: list of ref Atom;
		nextid: int;
		idindex: array of ref HashBucket;    # Hash table for ID lookups
		nameindex: array of ref HashBucket;  # Hash table for name lookups
		typeindex: array of ref HashBucket;  # Hash table for type lookups
		indexsize: int;
	};

	# Core AtomSpace operations
	init: fn(): ref Handle;
	addatom: fn(h: ref Handle, atype: int, name: string, tv: ref TruthValue): ref Atom;
	getatom: fn(h: ref Handle, id: int): ref Atom;
	removeatom: fn(h: ref Handle, id: int): int;
	getatoms: fn(h: ref Handle): list of ref Atom;
	
	# Truth value operations
	newtruthvalue: fn(strength: real, confidence: real): ref TruthValue;
	updatetruthvalue: fn(atom: ref Atom, tv: ref TruthValue);
	
	# Query operations
	findatomsbytype: fn(h: ref Handle, atype: int): list of ref Atom;
	findatomsbyname: fn(h: ref Handle, name: string): list of ref Atom;
	
	# Hash functions
	hashint: fn(val: int, size: int): int;
	hashstring: fn(str: string, size: int): int;
};
