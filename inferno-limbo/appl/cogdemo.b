implement Cogdemo;

include "sys.m";
	sys: Sys;
include "draw.m";

include "opencog.m";
	opencog: OpenCog;
include "atomspace.m";
	atomspace: AtomSpace;

Cogdemo: module
{
	init: fn(nil: ref Draw->Context, args: list of string);
};

init(nil: ref Draw->Context, args: list of string)
{
	sys = load Sys Sys->PATH;
	opencog = load OpenCog OpenCog->PATH;
	atomspace = load AtomSpace AtomSpace->PATH;
	
	sys->print("OpenCog Inferno Demo\n");
	sys->print("====================\n\n");
	
	# Initialize cognitive system
	cogsys := opencog->init();
	sys->print("Cognitive system initialized.\n");
	
	# Create some knowledge
	tv1 := atomspace->newtruthvalue(0.9, 0.8);
	tv2 := atomspace->newtruthvalue(0.85, 0.75);
	tv3 := atomspace->newtruthvalue(0.7, 0.9);
	
	sys->print("Adding knowledge to the system...\n");
	a1 := opencog->addknowledge(cogsys, "cat", tv1);
	a2 := opencog->addknowledge(cogsys, "mammal", tv2);
	a3 := opencog->addknowledge(cogsys, "animal", tv3);
	
	sys->print(sys->sprint("Added atom: %s (ID: %d)\n", a1.name, a1.id));
	sys->print(sys->sprint("Added atom: %s (ID: %d)\n", a2.name, a2.id));
	sys->print(sys->sprint("Added atom: %s (ID: %d)\n", a3.name, a3.id));
	
	# Query knowledge
	sys->print("\nQuerying for 'cat'...\n");
	results := opencog->query(cogsys, "cat");
	for (l := results; l != nil; l = tl l) {
		atom := hd l;
		sys->print(sys->sprint("Found: %s (strength: %.2f, confidence: %.2f)\n",
			atom.name, atom.tv.strength, atom.tv.confidence));
	}
	
	# Demonstrate reasoning
	sys->print("\nPerforming reasoning...\n");
	premises: list of string = "cat" :: "mammal" :: nil;
	inferences := opencog->reason(cogsys, premises);
	sys->print(sys->sprint("Generated %d inferences\n", len inferences));
	
	# Learning from examples
	sys->print("\nLearning from examples...\n");
	examples: list of (string, ref AtomSpace->TruthValue) = nil;
	examples = ("dog", atomspace->newtruthvalue(0.88, 0.82)) :: examples;
	examples = ("bird", atomspace->newtruthvalue(0.75, 0.85)) :: examples;
	opencog->learn(cogsys, examples);
	sys->print("Learning complete.\n");
	
	# Adaptation
	sys->print("\nAdapting based on feedback...\n");
	opencog->adapt(cogsys, 0.5);
	sys->print("Adaptation complete.\n");
	
	# Shutdown
	sys->print("\nShutting down cognitive system...\n");
	opencog->shutdown(cogsys);
	sys->print("Demo complete.\n");
}
