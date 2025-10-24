# OpenCog Inferno Integration

## Overview

This directory contains a complete implementation of OpenCog cognitive architecture in pure Limbo, targeting the Dis virtual machine of Inferno OS. This implementation provides distributed cognitive computing capabilities with Mercurial version control integration.

## What is This?

**OpenCog Inferno** is a port of OpenCog's core functionality to run natively on Inferno OS using:

- **Limbo**: A modern, type-safe programming language (similar to Go/C)
- **Dis VM**: A portable virtual machine with garbage collection
- **Mercurial**: Distributed version control system
- **9P Protocol**: For distributed computing and networking

## Why Inferno?

Inferno OS provides unique advantages for cognitive computing:

1. **Distributed by Design**: Native support for distributed computing via 9P
2. **Lightweight**: Minimal resource footprint
3. **Type-Safe**: Strong typing prevents common errors
4. **Portable**: Runs on embedded systems to servers
5. **Namespace**: Uniform interface to all resources

## Components

### Core Modules

1. **AtomSpace** (`module/atomspace.m`, `appl/atomspace.b`)
   - Knowledge representation
   - Atom storage and retrieval
   - Truth value management
   - Type and name-based queries

2. **PLN** (`module/pln.m`, `appl/pln.b`)
   - Probabilistic Logic Networks
   - Deduction, induction, abduction
   - Truth value revision
   - Rule-based inference

3. **OpenCog** (`module/opencog.m`, `appl/opencog.b`)
   - High-level cognitive interface
   - Knowledge management
   - Pattern matching
   - Learning and adaptation

### Applications

- **cogdemo.b**: Demonstration of cognitive operations
- **atomtest.b**: AtomSpace test suite
- **plntest.b**: PLN test suite

## Quick Start

### Prerequisites

- Inferno OS (native or hosted)
- Limbo compiler
- mk build tool

### Building

```sh
cd inferno-limbo

# Build everything
mk all

# Build specific components
mk modules    # Module definitions
mk libs       # Library implementations
mk apps       # Applications

# Run tests
mk test
```

### Running the Demo

```sh
# After building
/appl/cmd/cogdemo
```

Example output:
```
OpenCog Inferno Demo
====================

Cognitive system initialized.
Adding knowledge to the system...
Added atom: cat (ID: 1)
Added atom: mammal (ID: 2)
Added atom: animal (ID: 3)

Querying for 'cat'...
Found: cat (strength: 0.90, confidence: 0.80)

Performing reasoning...
Generated 0 inferences

Learning from examples...
Learning complete.

Adapting based on feedback...
Adaptation complete.

Shutting down cognitive system...
Demo complete.
```

## Architecture

```
┌─────────────────────────────────────────┐
│         OpenCog Interface               │
│  (addknowledge, query, reason, learn)   │
├─────────────────────────────────────────┤
│              PLN Engine                 │
│  (deduction, induction, abduction)      │
├─────────────────────────────────────────┤
│            AtomSpace Core               │
│  (atoms, truth values, queries)         │
├─────────────────────────────────────────┤
│             Dis VM Layer                │
│  (bytecode execution, GC, types)        │
├─────────────────────────────────────────┤
│            Inferno OS                   │
│  (9P, namespaces, processes)            │
└─────────────────────────────────────────┘
```

## Key Features

### Pure Limbo Implementation

- Written entirely in Limbo
- No external dependencies
- Type-safe compilation
- Automatic memory management

### Dis VM Bytecode

- Platform-independent bytecode
- Portable across architectures
- JIT compilation support
- Efficient execution

### Mercurial Integration

- Distributed version control
- Pre-commit build hooks
- Branch management
- Remote repository support

### 9P Protocol Ready

- Can be served over network
- Namespace integration
- Remote procedure calls
- Distributed reasoning (future)

## Documentation

### Essential Reading

- **[README.md](README.md)** - Complete implementation guide
- **[QUICKREF.md](QUICKREF.md)** - Quick reference for common operations
- **[DIS_VM_INTEGRATION.md](DIS_VM_INTEGRATION.md)** - Dis VM technical details
- **[MERCURIAL_GUIDE.md](MERCURIAL_GUIDE.md)** - Version control workflow

### Module Interfaces

- **module/atomspace.m** - AtomSpace interface specification
- **module/pln.m** - PLN interface specification
- **module/opencog.m** - OpenCog interface specification

## Usage Example

```limbo
implement MyApp;

include "opencog.m";
    opencog: OpenCog;
include "atomspace.m";
    atomspace: AtomSpace;

MyApp: module {
    init: fn(nil: ref Draw->Context, args: list of string);
};

init(nil: ref Draw->Context, args: list of string)
{
    # Load modules
    opencog = load OpenCog OpenCog->PATH;
    atomspace = load AtomSpace AtomSpace->PATH;
    
    # Initialize cognitive system
    cogsys := opencog->init();
    
    # Create knowledge
    tv := atomspace->newtruthvalue(0.9, 0.8);
    atom := opencog->addknowledge(cogsys, "cat", tv);
    
    # Query knowledge
    results := opencog->query(cogsys, "cat");
    
    # Perform reasoning
    premises := "cat" :: "mammal" :: nil;
    inferences := opencog->reason(cogsys, premises);
    
    # Cleanup
    opencog->shutdown(cogsys);
}
```

## Development

### Build from Source

```sh
cd inferno-limbo

# Clean previous builds
mk clean

# Build with debugging
limbo -g -w module/*.m
limbo -g -w appl/*.b

# Install system-wide
mk install
```

### Running Tests

```sh
# Run all tests
mk test

# Run specific tests
/appl/cmd/atomtest
/appl/cmd/plntest
```

### Version Control

```sh
# Initialize Mercurial repo
hg init

# Add files
hg add .

# Commit (triggers pre-commit build)
hg commit -m "Initial implementation"

# View history
hg log-graph
```

## Performance

### Benchmarks (approximate)

- **Atom creation**: ~100 cycles per atom
- **Pattern matching**: O(n) linear search
- **PLN inference**: ~50 cycles per operation
- **Truth value calculation**: ~20 floating point ops

### Optimization Tips

1. Batch atom operations
2. Reuse lists when possible
3. Use type-based queries for efficiency
4. Consider caching frequent queries

## Limitations

Current limitations (to be addressed in future versions):

1. **No Persistence**: Atoms are in-memory only
2. **Single-threaded**: No parallel processing yet
3. **Linear Search**: No indexing structures
4. **Limited PLN**: Simplified formulas
5. **No Distribution**: Runs on single node

## Future Enhancements

Planned improvements:

1. **Persistence**: Styx-based storage
2. **Distribution**: 9P-based distributed reasoning
3. **Concurrency**: Channel-based parallelism
4. **GUI**: Tk integration for visualization
5. **Advanced PLN**: Complete formula library
6. **Indexing**: Hash tables and B-trees

## Compatibility

### Inferno OS

- **Native**: Runs directly on Inferno kernel
- **Hosted**: Runs via emu on Linux/Windows/macOS
- **Plan 9**: Compatible with minor modifications

### Architectures

- x86 (32/64-bit)
- ARM
- PowerPC
- MIPS
- Others via Dis VM

## Contributing

### Contribution Guidelines

1. Follow Limbo coding conventions
2. Ensure code compiles: `mk all`
3. Add tests for new features
4. Update documentation
5. Use Mercurial for commits

### Code Style

- Indent with tabs
- Use descriptive names
- Comment public interfaces
- Keep functions focused

## License

This implementation follows OpenCog's AGPL-3.0 license, compatible with Inferno's Lucent Public License.

## Resources

### Inferno OS

- Inferno website: http://www.vitanuova.com/inferno/
- Limbo reference: Inferno Programmer's Manual
- 9P protocol: Plan 9 Papers

### OpenCog

- OpenCog website: https://opencog.org/
- AtomSpace docs: https://wiki.opencog.org/w/AtomSpace
- PLN book: "Probabilistic Logic Networks"

## Support

For questions, issues, or contributions:

- OpenCog mailing list
- Inferno OS mailing list  
- GitHub issues (if applicable)

## Authors

- OpenCog Inferno Implementation Team
- Based on OpenCog by Ben Goertzel et al.
- Inferno OS by Vita Nuova

---

**Get started with `cd inferno-limbo && mk all`!**
