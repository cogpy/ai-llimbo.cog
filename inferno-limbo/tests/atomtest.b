implement Atomtest;

include "sys.m";
	sys: Sys;
include "draw.m";

include "atomspace.m";
	atomspace: AtomSpace;

Atomtest: module
{
	init: fn(nil: ref Draw->Context, args: list of string);
};

init(nil: ref Draw->Context, args: list of string)
{
	sys = load Sys Sys->PATH;
	atomspace = load AtomSpace AtomSpace->PATH;
	
	sys->print("AtomSpace Test Suite\n");
	sys->print("====================\n\n");
	
	failed := 0;
	passed := 0;
	
	# Test 1: Initialize AtomSpace
	sys->print("Test 1: Initialize AtomSpace... ");
	handle := atomspace->init();
	if (handle != nil && handle.nextid == 1) {
		sys->print("PASS\n");
		passed++;
	} else {
		sys->print("FAIL\n");
		failed++;
	}
	
	# Test 2: Create TruthValue
	sys->print("Test 2: Create TruthValue... ");
	tv := atomspace->newtruthvalue(0.9, 0.8);
	if (tv != nil && tv.strength == 0.9 && tv.confidence == 0.8) {
		sys->print("PASS\n");
		passed++;
	} else {
		sys->print("FAIL\n");
		failed++;
	}
	
	# Test 3: Add Atom
	sys->print("Test 3: Add Atom... ");
	atom := atomspace->addatom(handle, 3, "test_concept", tv);
	if (atom != nil && atom.id == 1 && atom.name == "test_concept") {
		sys->print("PASS\n");
		passed++;
	} else {
		sys->print("FAIL\n");
		failed++;
	}
	
	# Test 4: Get Atom by ID
	sys->print("Test 4: Get Atom by ID... ");
	retrieved := atomspace->getatom(handle, 1);
	if (retrieved != nil && retrieved.name == "test_concept") {
		sys->print("PASS\n");
		passed++;
	} else {
		sys->print("FAIL\n");
		failed++;
	}
	
	# Test 5: Add multiple atoms
	sys->print("Test 5: Add multiple atoms... ");
	tv2 := atomspace->newtruthvalue(0.8, 0.7);
	atom2 := atomspace->addatom(handle, 3, "second_concept", tv2);
	atom3 := atomspace->addatom(handle, 4, "predicate", tv);
	if (atom2.id == 2 && atom3.id == 3 && handle.nextid == 4) {
		sys->print("PASS\n");
		passed++;
	} else {
		sys->print("FAIL\n");
		failed++;
	}
	
	# Test 6: Get all atoms
	sys->print("Test 6: Get all atoms... ");
	all := atomspace->getatoms(handle);
	count := 0;
	for (l := all; l != nil; l = tl l)
		count++;
	if (count == 3) {
		sys->print("PASS\n");
		passed++;
	} else {
		sys->print(sys->sprint("FAIL (expected 3, got %d)\n", count));
		failed++;
	}
	
	# Test 7: Find atoms by type
	sys->print("Test 7: Find atoms by type... ");
	concepts := atomspace->findatomsbytype(handle, 3);
	count = 0;
	for (l := concepts; l != nil; l = tl l)
		count++;
	if (count == 2) {
		sys->print("PASS\n");
		passed++;
	} else {
		sys->print(sys->sprint("FAIL (expected 2, got %d)\n", count));
		failed++;
	}
	
	# Test 8: Find atoms by name
	sys->print("Test 8: Find atoms by name... ");
	found := atomspace->findatomsbyname(handle, "test_concept");
	if (found != nil && (hd found).name == "test_concept") {
		sys->print("PASS\n");
		passed++;
	} else {
		sys->print("FAIL\n");
		failed++;
	}
	
	# Test 9: Update truth value
	sys->print("Test 9: Update truth value... ");
	newtv := atomspace->newtruthvalue(0.95, 0.85);
	atomspace->updatetruthvalue(atom, newtv);
	if (atom.tv.strength == 0.95 && atom.tv.confidence == 0.85) {
		sys->print("PASS\n");
		passed++;
	} else {
		sys->print("FAIL\n");
		failed++;
	}
	
	# Test 10: Remove atom
	sys->print("Test 10: Remove atom... ");
	status := atomspace->removeatom(handle, 2);
	remaining := atomspace->getatoms(handle);
	count = 0;
	for (l := remaining; l != nil; l = tl l)
		count++;
	if (status == 1 && count == 2) {
		sys->print("PASS\n");
		passed++;
	} else {
		sys->print(sys->sprint("FAIL (status=%d, count=%d)\n", status, count));
		failed++;
	}
	
	# Summary
	sys->print(sys->sprint("\n====================\n"));
	sys->print(sys->sprint("Tests passed: %d\n", passed));
	sys->print(sys->sprint("Tests failed: %d\n", failed));
	sys->print(sys->sprint("Total tests: %d\n", passed + failed));
	
	if (failed == 0)
		sys->print("\nAll tests PASSED!\n");
	else
		sys->print("\nSome tests FAILED!\n");
}
