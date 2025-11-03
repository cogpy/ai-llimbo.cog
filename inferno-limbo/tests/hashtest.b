implement HashTest;

include "sys.m";
	sys: Sys;
	print: import sys;

include "atomspace.m";
	atomspace: AtomSpace;

HashTest: module
{
	init: fn(nil: ref Draw->Context, nil: list of string);
};

init(nil: ref Draw->Context, nil: list of string)
{
	sys = load Sys Sys->PATH;
	atomspace = load AtomSpace AtomSpace->PATH;
	
	print("Hash Indexing Performance Test\n");
	print("================================\n\n");
	
	# Test 1: Hash function consistency
	print("Test 1: Hash function consistency... ");
	h1 := atomspace->hashint(42, 256);
	h2 := atomspace->hashint(42, 256);
	if (h1 == h2)
		print("PASS\n");
	else
		print("FAIL\n");
	
	# Test 2: String hash consistency
	print("Test 2: String hash consistency... ");
	s1 := atomspace->hashstring("test", 256);
	s2 := atomspace->hashstring("test", 256);
	if (s1 == s2)
		print("PASS\n");
	else
		print("FAIL\n");
	
	# Test 3: Hash distribution
	print("Test 3: Hash distribution... ");
	h := atomspace->init();
	
	# Add many atoms
	for (i := 0; i < 100; i++) {
		tv := atomspace->newtruthvalue(0.8, 0.9);
		atomspace->addatom(h, 1, sys->sprint("atom_%d", i), tv);
	}
	
	# Test fast retrieval
	start := sys->millisec();
	for (i := 0; i < 100; i++) {
		atom := atomspace->getatom(h, i + 1);
		if (atom == nil) {
			print("FAIL - atom not found\n");
			return;
		}
	}
	elapsed := sys->millisec() - start;
	print("PASS (");
	print(sys->sprint("%d", elapsed));
	print("ms for 100 lookups)\n");
	
	# Test 4: Name-based hash lookup
	print("Test 4: Name-based hash lookup... ");
	results := atomspace->findatomsbyname(h, "atom_50");
	if (results != nil && (hd results).name == "atom_50")
		print("PASS\n");
	else
		print("FAIL\n");
	
	# Test 5: Type-based hash lookup
	print("Test 5: Type-based hash lookup... ");
	results = atomspace->findatomsbytype(h, 1);
	count := 0;
	for (l := results; l != nil; l = tl l)
		count++;
	if (count == 100)
		print("PASS\n");
	else {
		print("FAIL (found ");
		print(sys->sprint("%d", count));
		print(" atoms)\n");
	}
	
	# Test 6: Performance comparison
	print("Test 6: Large-scale performance... ");
	h2 := atomspace->init();
	
	# Add 1000 atoms
	for (i := 0; i < 1000; i++) {
		tv := atomspace->newtruthvalue(0.7, 0.8);
		atomspace->addatom(h2, i % 10, sys->sprint("atom_%d", i), tv);
	}
	
	# Test retrieval performance
	start = sys->millisec();
	for (i := 0; i < 1000; i++) {
		atom := atomspace->getatom(h2, i + 1);
		if (atom == nil) {
			print("FAIL - atom not found\n");
			return;
		}
	}
	elapsed = sys->millisec() - start;
	print("PASS (");
	print(sys->sprint("%d", elapsed));
	print("ms for 1000 lookups)\n");
	
	print("\nAll hash indexing tests completed!\n");
}
