implement ExtPLNTest;

include "sys.m";
	sys: Sys;
	print: import sys;

include "atomspace.m";
	atomspace: AtomSpace;
include "pln.m";
	pln: PLN;

ExtPLNTest: module
{
	init: fn(nil: ref Draw->Context, nil: list of string);
};

init(nil: ref Draw->Context, nil: list of string)
{
	sys = load Sys Sys->PATH;
	atomspace = load AtomSpace AtomSpace->PATH;
	pln = load PLN PLN->PATH;
	
	print("Extended PLN Formula Test\n");
	print("=========================\n\n");
	
	# Initialize
	h := atomspace->init();
	engine := pln->init(h);
	
	# Create test atoms
	tv1 := atomspace->newtruthvalue(0.8, 0.9);
	tv2 := atomspace->newtruthvalue(0.6, 0.85);
	
	atom1 := atomspace->addatom(h, 3, "cat", tv1);
	atom2 := atomspace->addatom(h, 3, "mammal", tv2);
	
	# Test 1: Disjunction (OR)
	print("Test 1: Disjunction (OR)... ");
	tv_or := pln->disjunction(atom1, atom2);
	# Expected: s = 0.8 + 0.6 - 0.8*0.6 = 0.92
	if (tv_or.strength > 0.91 && tv_or.strength < 0.93)
		print("PASS\n");
	else {
		print("FAIL (strength=");
		print(sys->sprint("%g", tv_or.strength));
		print(")\n");
	}
	
	# Test 2: Negation (NOT)
	print("Test 2: Negation (NOT)... ");
	tv_not := pln->negation(atom1);
	# Expected: s = 1 - 0.8 = 0.2
	if (tv_not.strength > 0.19 && tv_not.strength < 0.21)
		print("PASS\n");
	else {
		print("FAIL (strength=");
		print(sys->sprint("%g", tv_not.strength));
		print(")\n");
	}
	
	# Test 3: Similarity
	print("Test 3: Similarity... ");
	tv_sim := pln->similarity(atom1, atom2);
	# Expected: s = 1 - |0.8 - 0.6| = 0.8
	if (tv_sim.strength > 0.79 && tv_sim.strength < 0.81)
		print("PASS\n");
	else {
		print("FAIL (strength=");
		print(sys->sprint("%g", tv_sim.strength));
		print(")\n");
	}
	
	# Test 4: Implication
	print("Test 4: Implication... ");
	tv_imp := pln->implication(atom1, atom2);
	# Expected: s = 0.6 / 0.8 = 0.75
	if (tv_imp.strength > 0.74 && tv_imp.strength < 0.76)
		print("PASS\n");
	else {
		print("FAIL (strength=");
		print(sys->sprint("%g", tv_imp.strength));
		print(")\n");
	}
	
	# Test 5: Combined operations
	print("Test 5: Combined operations... ");
	# NOT(cat) OR mammal
	tv_not_cat := pln->negation(atom1);
	atom_not_cat := atomspace->addatom(h, 3, "not_cat", tv_not_cat);
	tv_combined := pln->disjunction(atom_not_cat, atom2);
	# Should be valid truth value
	if (tv_combined.strength >= 0.0 && tv_combined.strength <= 1.0)
		print("PASS\n");
	else
		print("FAIL\n");
	
	# Test 6: Similarity of identical atoms
	print("Test 6: Similarity of identical... ");
	tv_self := pln->similarity(atom1, atom1);
	# Expected: s = 1.0 (identical)
	if (tv_self.strength > 0.99)
		print("PASS\n");
	else {
		print("FAIL (strength=");
		print(sys->sprint("%g", tv_self.strength));
		print(")\n");
	}
	
	# Test 7: Disjunction with high confidence
	print("Test 7: Disjunction confidence... ");
	tv_or2 := pln->disjunction(atom1, atom2);
	# Confidence should be product
	expected_conf := 0.9 * 0.85;
	if (tv_or2.confidence > expected_conf - 0.01 && 
	    tv_or2.confidence < expected_conf + 0.01)
		print("PASS\n");
	else {
		print("FAIL (confidence=");
		print(sys->sprint("%g", tv_or2.confidence));
		print(")\n");
	}
	
	# Test 8: Negation preserves confidence
	print("Test 8: Negation confidence... ");
	if (tv_not.confidence > 0.89 && tv_not.confidence < 0.91)
		print("PASS\n");
	else {
		print("FAIL (confidence=");
		print(sys->sprint("%g", tv_not.confidence));
		print(")\n");
	}
	
	print("\nAll extended PLN tests completed!\n");
}
