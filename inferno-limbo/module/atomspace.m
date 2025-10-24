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

	# AtomSpace handle
	Handle: adt {
		atoms: list of ref Atom;
		nextid: int;
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
};
