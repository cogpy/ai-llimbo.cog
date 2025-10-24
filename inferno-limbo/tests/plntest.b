implement Plntest;

include "sys.m";
	sys: Sys;
include "draw.m";
include "math.m";
	math: Math;

include "atomspace.m";
	atomspace: AtomSpace;
include "pln.m";
	pln: PLN;

Plntest: module
{
	init: fn(nil: ref Draw->Context, args: list of string);
};

init(nil: ref Draw->Context, args: list of string)
{
	sys = load Sys Sys->PATH;
	math = load Math Math->PATH;
	atomspace = load AtomSpace AtomSpace->PATH;
	pln = load PLN PLN->PATH;
	
	sys->print("PLN Test Suite\n");
	sys->print("===============\n\n");
	
	failed := 0;
	passed := 0;
	
	# Setup
	handle := atomspace->init();
	engine := pln->init(handle);
	
	# Test 1: Initialize PLN
	sys->print("Test 1: Initialize PLN engine... ");
	if (engine != nil && engine.atomspace != nil) {
		sys->print("PASS\n");
		passed++;
	} else {
		sys->print("FAIL\n");
		failed++;
	}
	
	# Test 2: Deduction
	sys->print("Test 2: Deduction inference... ");
	tv1 := atomspace->newtruthvalue(0.9, 0.8);
	tv2 := atomspace->newtruthvalue(0.8, 0.7);
	a1 := atomspace->addatom(handle, 7, "A->B", tv1);
	a2 := atomspace->addatom(handle, 7, "B->C", tv2);
	result := pln->deduction(a1, a2);
	expected_s := 0.72;  # 0.9 * 0.8
	expected_c := 0.504; # 0.8 * 0.7 * 0.9
	diff_s := math->fabs(result.tv.strength - expected_s);
	diff_c := math->fabs(result.tv.confidence - expected_c);
	if (diff_s < 0.01 && diff_c < 0.01) {
		sys->print("PASS\n");
		passed++;
	} else {
		sys->print(sys->sprint("FAIL (s=%.3f, c=%.3f)\n", 
			result.tv.strength, result.tv.confidence));
		failed++;
	}
	
	# Test 3: Induction
	sys->print("Test 3: Induction inference... ");
	result = pln->induction(a1, a2);
	if (result != nil && result.tv.strength < a1.tv.strength) {
		sys->print("PASS\n");
		passed++;
	} else {
		sys->print("FAIL\n");
		failed++;
	}
	
	# Test 4: Abduction
	sys->print("Test 4: Abduction inference... ");
	result = pln->abduction(a1, a2);
	if (result != nil && result.tv != nil) {
		sys->print("PASS\n");
		passed++;
	} else {
		sys->print("FAIL\n");
		failed++;
	}
	
	# Test 5: Revision
	sys->print("Test 5: Truth value revision... ");
	revised := pln->revision(a1, a2);
	if (revised != nil && revised.confidence > a1.tv.confidence) {
		sys->print("PASS\n");
		passed++;
	} else {
		sys->print("FAIL\n");
		failed++;
	}
	
	# Test 6: Conjunction
	sys->print("Test 6: Conjunction operation... ");
	conj := pln->conjunction(a1, a2);
	expected := 0.56;  # 0.8 * 0.7
	diff := math->fabs(conj.confidence - expected);
	if (diff < 0.01) {
		sys->print("PASS\n");
		passed++;
	} else {
		sys->print(sys->sprint("FAIL (expected %.2f, got %.2f)\n", 
			expected, conj.confidence));
		failed++;
	}
	
	# Test 7: Add rule
	sys->print("Test 7: Add inference rule... ");
	rule := ref PLN->Rule;
	rule.name = "test_rule";
	rule.premises = 1 :: 2 :: nil;
	rule.conclusion = 3;
	rule.confidence = 0.9;
	pln->addrule(engine, rule);
	# Check if rule was added (count rules)
	count := 0;
	for (l := engine.rules; l != nil; l = tl l)
		count++;
	if (count == 1) {
		sys->print("PASS\n");
		passed++;
	} else {
		sys->print("FAIL\n");
		failed++;
	}
	
	# Test 8: Inference
	sys->print("Test 8: Perform inference... ");
	# Add conclusion atom
	tv3 := atomspace->newtruthvalue(0.85, 0.75);
	atomspace->addatom(handle, 3, "conclusion", tv3);
	# Infer with matching premises
	inferences := pln->infer(engine, 1 :: 2 :: nil);
	if (inferences != nil) {
		sys->print("PASS\n");
		passed++;
	} else {
		sys->print("FAIL\n");
		failed++;
	}
	
	# Summary
	sys->print(sys->sprint("\n===============\n"));
	sys->print(sys->sprint("Tests passed: %d\n", passed));
	sys->print(sys->sprint("Tests failed: %d\n", failed));
	sys->print(sys->sprint("Total tests: %d\n", passed + failed));
	
	if (failed == 0)
		sys->print("\nAll tests PASSED!\n");
	else
		sys->print("\nSome tests FAILED!\n");
}
