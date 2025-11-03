# OpenCog Inferno - Pure Limbo Implementation

## Overview

This is a pure Limbo implementation of OpenCog cognitive architecture designed to run on the Inferno operating system's Dis virtual machine. This implementation provides core cognitive capabilities including knowledge representation, reasoning, and learning.

## Architecture

### Components

1. **AtomSpace** - Core knowledge representation
   - Atom storage and retrieval
   - Truth value management
   - Type-based querying
   - Name-based searching

2. **PLN (Probabilistic Logic Networks)** - Reasoning engine
   - Deduction, induction, and abduction
   - Truth value revision
   - Conjunction operations
   - Rule-based inference

3. **OpenCog** - High-level cognitive interface
   - Knowledge management
   - Pattern matching
   - Learning from examples
   - Adaptive behavior

### Dis VM Compatibility

All modules are compiled to Dis bytecode (.dis files) which run on the Dis virtual machine. The Dis VM provides:

- Garbage collection
- Type safety
- Module isolation
- Cross-platform execution

## Building

### Prerequisites

- Inferno OS or Inferno hosted environment
- Limbo compiler (limbo)
- mk build tool

### Build Commands

```sh
# Build all modules and applications
mk all

# Build only modules
mk modules

# Build only applications
mk apps

# Clean build artifacts
mk clean

# Install to system directories
mk install

# Run tests
mk test

# Complete removal
mk nuke
```

## File Structure

```
inferno-limbo/
├── module/           # Module definitions (.m files)
│   ├── atomspace.m   # AtomSpace interface
│   ├── pln.m         # PLN interface
│   └── opencog.m     # OpenCog interface
├── appl/             # Implementations (.b files)
│   ├── atomspace.b   # AtomSpace implementation
│   ├── pln.b         # PLN implementation
│   ├── opencog.b     # OpenCog implementation
│   └── cogdemo.b     # Demonstration application
├── mkfile            # Build configuration
├── .hgignore         # Mercurial ignore patterns
└── .hg/
    └── hgrc          # Mercurial configuration
```

## Usage

### Basic Example

```limbo
implement MyApp;

include "opencog.m";
    opencog: OpenCog;
include "atomspace.m";
    atomspace: AtomSpace;

# Initialize cognitive system
cogsys := opencog->init();

# Create knowledge
tv := atomspace->newtruthvalue(0.9, 0.8);
atom := opencog->addknowledge(cogsys, "cat", tv);

# Query
results := opencog->query(cogsys, "cat");

# Reason
premises := "cat" :: "mammal" :: nil;
inferences := opencog->reason(cogsys, premises);

# Cleanup
opencog->shutdown(cogsys);
```

### Running the Demo

```sh
# After building
/appl/cmd/cogdemo
```

## Module Interfaces

### AtomSpace

Provides core atom management:

- `init()` - Initialize atom space
- `addatom()` - Add new atom
- `getatom()` - Retrieve atom by ID
- `removeatom()` - Remove atom
- `findatomsbytype()` - Query by type
- `findatomsbyname()` - Query by name

### PLN

Implements probabilistic reasoning:

- `init()` - Initialize PLN engine
- `deduction()` - A→B, B→C ⇒ A→C
- `induction()` - A→B ⇒ B→A
- `abduction()` - B→C, A→C ⇒ A→B
- `revision()` - Combine truth values
- `conjunction()` - AND operation

### OpenCog

High-level cognitive operations:

- `init()` - Initialize cognitive system
- `addknowledge()` - Add concepts
- `query()` - Search knowledge base
- `reason()` - Perform inference
- `learn()` - Learn from examples
- `adapt()` - Adapt based on feedback
- `patternmatch()` - Pattern matching

## Mercurial Integration

This implementation includes Mercurial version control integration:

### Configuration

The `.hg/hgrc` file configures:

- Default repository paths
- Commit hooks (build verification)
- Merge tools (acme editor)
- Useful aliases

### Workflow

```sh
# Initialize repository (if not already done)
hg init

# Check status
hg st

# Commit changes
hg ci -m "Description"

# View log
hg log-graph

# Push to remote
hg push
```

### Pre-commit Hooks

The configuration includes a pre-commit hook that ensures code builds before committing:

```
precommit.build = mk clean && mk all
```

## Technical Details

### Truth Values

Truth values in this implementation use a two-dimensional representation:

- **Strength**: Probability (0.0 to 1.0)
- **Confidence**: Certainty of the estimate (0.0 to 1.0)

### Atom Types

Predefined atom types:

- `NODE` (1) - Generic node
- `LINK` (2) - Generic link
- `CONCEPT_NODE` (3) - Concept representation
- `PREDICATE_NODE` (4) - Predicate
- `INHERITANCE_LINK` (5) - Inheritance relationship
- `SIMILARITY_LINK` (6) - Similarity relationship
- `IMPLICATION_LINK` (7) - Logical implication

### PLN Formulas

The implementation uses standard PLN formulas:

**Deduction**: 
- strength = s_AB × s_BC
- confidence = c_AB × c_BC × s_AB

**Revision**:
- strength = w1 × s1 + w2 × s2 (where w = c/(c1+c2))
- confidence = c1 + c2 - c1 × c2

## Performance Considerations

- Atoms stored in linked lists for simplicity
- Linear search complexity O(n)
- For production use, consider hash tables
- Dis VM provides automatic garbage collection

## Compatibility

- **Inferno OS**: Native support
- **Dis VM**: Primary target
- **Hosted Inferno**: Runs on Linux, Windows, macOS
- **Plan 9**: Compatible with minor modifications

## Limitations

This is a minimal implementation focusing on core functionality:

- No persistence layer (atoms lost on shutdown)
- Basic pattern matching (exact or prefix)
- Simplified PLN formulas
- No distributed processing
- Limited to single-threaded execution

## Future Enhancements

Potential improvements:

1. Persistent storage using Inferno's styx protocol
2. Network transparency via 9P
3. Distributed reasoning across namespaces
4. Integration with Inferno's GUI (tk)
5. Advanced pattern matching with unification
6. Extended PLN formula library
7. Multi-agent coordination

## References

- Inferno OS: http://www.vitanuova.com/inferno/
- OpenCog: https://opencog.org/
- PLN Book: "Probabilistic Logic Networks"
- Limbo Language: Inferno Programmer's Manual

## License

This implementation follows the same license as OpenCog:
AGPL-3.0 (or compatible with Inferno's license terms)

## Contributing

To contribute:

1. Follow Limbo coding conventions
2. Ensure code compiles with `mk all`
3. Test with `mk test`
4. Use Mercurial for version control
5. Submit patches via email or pull requests

## Contact

For questions or contributions, contact the OpenCog community or the Inferno OS mailing lists.
