# OpenCog Inferno Quick Reference

## Build Commands

```sh
mk all          # Build everything
mk modules      # Build module definitions
mk libs         # Build library implementations  
mk apps         # Build applications
mk clean        # Remove build artifacts
mk install      # Install to system
mk test         # Run demo/tests
mk nuke         # Complete cleanup
```

## Module Loading

```limbo
include "opencog.m";
    opencog: OpenCog;
include "atomspace.m";
    atomspace: AtomSpace;
include "pln.m";
    pln: PLN;
include "atomtypes.m";
    atomtypes: AtomTypes;
```

## Common Operations

### Initialize System

```limbo
cogsys := opencog->init();
```

### Create Truth Value

```limbo
tv := atomspace->newtruthvalue(0.9, 0.8);  # strength, confidence
```

### Add Knowledge

```limbo
atom := opencog->addknowledge(cogsys, "concept_name", tv);
```

### Query Knowledge

```limbo
results := opencog->query(cogsys, "pattern");
```

### Perform Reasoning

```limbo
premises := "premise1" :: "premise2" :: nil;
inferences := opencog->reason(cogsys, premises);
```

### Learn from Examples

```limbo
examples := ("cat", tv1) :: ("dog", tv2) :: nil;
opencog->learn(cogsys, examples);
```

### Pattern Matching

```limbo
pattern := ref AtomSpace->Atom;  # Define pattern
results := opencog->patternmatch(cogsys, pattern);
```

### Shutdown

```limbo
opencog->shutdown(cogsys);
```

## PLN Operations

### Deduction

```limbo
result := pln->deduction(atom_a, atom_b);  # A→B, B→C ⇒ A→C
```

### Induction

```limbo
result := pln->induction(atom_a, atom_b);  # A→B ⇒ B→A
```

### Abduction

```limbo
result := pln->abduction(atom_a, atom_b);  # B→C, A→C ⇒ A→B
```

### Revision

```limbo
new_tv := pln->revision(atom_a, atom_b);  # Combine truth values
```

## Atom Types

```limbo
NODE                # 1
LINK                # 2
CONCEPT_NODE        # 3
PREDICATE_NODE      # 4
INHERITANCE_LINK    # 5
SIMILARITY_LINK     # 6
IMPLICATION_LINK    # 7
```

## AtomSpace Operations

```limbo
# Initialize
handle := atomspace->init();

# Add atom
atom := atomspace->addatom(handle, CONCEPT_NODE, "name", tv);

# Get by ID
atom := atomspace->getatom(handle, atom_id);

# Remove
status := atomspace->removeatom(handle, atom_id);

# Find by type
atoms := atomspace->findatomsbytype(handle, CONCEPT_NODE);

# Find by name
atoms := atomspace->findatomsbyname(handle, "name");

# Get all
all_atoms := atomspace->getatoms(handle);

# Update truth value
atomspace->updatetruthvalue(atom, new_tv);
```

## File Extensions

- `.m` - Module definition (interface)
- `.b` - Limbo implementation
- `.dis` - Compiled Dis bytecode
- `.sbl` - Symbol table (debug)

## Mercurial Commands

```sh
hg st              # Status
hg ci -m "msg"     # Commit
hg log-graph       # View log
hg push            # Push changes
```

## Directory Structure

```
/dis/lib/          # Compiled libraries (.dis)
/module/           # Module definitions (.m)
/appl/cmd/         # Applications
```

## Example Program

```limbo
implement MyApp;

include "sys.m";
    sys: Sys;
include "opencog.m";
    opencog: OpenCog;
include "atomspace.m";
    atomspace: AtomSpace;

MyApp: module {
    init: fn(nil: ref Draw->Context, args: list of string);
};

init(nil: ref Draw->Context, args: list of string)
{
    sys = load Sys Sys->PATH;
    opencog = load OpenCog OpenCog->PATH;
    atomspace = load AtomSpace AtomSpace->PATH;
    
    # Initialize
    cogsys := opencog->init();
    
    # Add knowledge
    tv := atomspace->newtruthvalue(0.9, 0.8);
    atom := opencog->addknowledge(cogsys, "cat", tv);
    
    # Query
    results := opencog->query(cogsys, "cat");
    
    # Print results
    for (l := results; l != nil; l = tl l) {
        a := hd l;
        sys->print(sys->sprint("%s\n", a.name));
    }
    
    # Cleanup
    opencog->shutdown(cogsys);
}
```

## Debugging

```sh
# Compile with debugging symbols
limbo -g program.b

# Check for warnings
limbo -w program.b

# View symbol table
cat program.sbl
```

## Common Issues

**Module not found**: Ensure module path is correct and modules are built

**Type mismatch**: Check ADT definitions match between .m and .b files

**Build fails**: Run `mk clean` first, then `mk all`

**Import errors**: Verify include paths and module loading

## Performance Tips

- Use list operations efficiently
- Minimize atom space searches
- Batch operations when possible
- Consider atom caching for frequent access

## Integration

This implementation can integrate with:

- Inferno's styx/9P for networking
- tk toolkit for GUI
- sh for shell scripting
- Native Inferno applications

## Documentation

- Full documentation: `README.md`
- Module interfaces: `module/*.m`
- Example code: `appl/cogdemo.b`
