# Dis VM Integration Guide

## Overview

This document explains how OpenCog components are compiled and executed on the Dis virtual machine in Inferno OS.

## The Dis Virtual Machine

### Architecture

The Dis VM is a portable virtual machine designed for distributed systems:

- **Type-safe bytecode execution**
- **Automatic garbage collection**
- **Module system with strong typing**
- **Built-in concurrency (channels and threads)**
- **Memory safety guarantees**

### Bytecode Format

Limbo source (.b files) compiles to Dis bytecode (.dis files):

```
Source (.b) → Limbo Compiler → Bytecode (.dis) → Dis VM → Execution
```

### Module System

Modules provide abstraction boundaries:

1. **Module Definition (.m)**: Interface specification
2. **Implementation (.b)**: Concrete implementation
3. **Bytecode (.dis)**: Compiled form

## OpenCog on Dis VM

### Memory Model

#### Atom Storage

Atoms are stored as heap-allocated ADTs:

```limbo
Atom: adt {
    id: int;           # 4 bytes
    atype: int;        # 4 bytes
    name: string;      # Reference (4 bytes) + heap data
    tv: ref TruthValue;# Reference (4 bytes)
};
```

Total per atom: ~16 bytes + string length + TruthValue

#### Lists

Limbo lists are linked structures with automatic garbage collection:

```limbo
list of ref Atom
```

Each node: 8 bytes (element + next pointer)

### Type Safety

The Dis VM enforces type safety at runtime:

```limbo
# Type checking prevents errors
atom: ref Atom = getatom(handle, 1);
# Cannot assign incompatible types
atom = tv;  # Compile error!
```

### Garbage Collection

Dis VM uses mark-and-sweep garbage collection:

- Atoms automatically freed when unreferenced
- Lists cleaned up when out of scope
- No manual memory management needed

## Compilation Process

### Step 1: Module Definition

Define interfaces in `.m` files:

```limbo
AtomSpace: module {
    PATH: con "/dis/lib/atomspace.dis";
    
    Atom: adt { ... };
    
    init: fn(): ref Handle;
    addatom: fn(...): ref Atom;
};
```

### Step 2: Implementation

Implement in `.b` files:

```limbo
implement AtomSpace;

include "sys.m";
include "atomspace.m";

init(): ref Handle {
    # Implementation
}
```

### Step 3: Compilation

```sh
limbo -I/module atomspace.b
```

Produces:
- `atomspace.dis` - Bytecode
- `atomspace.sbl` - Symbol table (with -g flag)

### Step 4: Loading

Runtime module loading:

```limbo
atomspace = load AtomSpace AtomSpace->PATH;
```

The Dis VM:
1. Locates bytecode file
2. Verifies type signatures
3. Links module
4. Initializes module data

## Dis VM Instructions

Key instructions used in OpenCog:

### Data Movement

- `MOVW` - Move word (int, references)
- `MOVF` - Move float (real)
- `MOVP` - Move pointer

### Arithmetic

- `ADDF` - Add floats (truth value calculations)
- `MULF` - Multiply floats (PLN formulas)
- `DIVF` - Divide floats

### Control Flow

- `GOTO` - Unconditional jump
- `BEQW` - Branch if equal
- `BNEW` - Branch if not equal

### Memory

- `NEW` - Allocate heap object
- `NEWZ` - Allocate and zero
- `MOVM` - Block memory move

### Lists

- `HEAD` - Get list head
- `TAIL` - Get list tail
- `CONS` - Construct list node

## Performance Characteristics

### Operation Costs (approximate cycles)

| Operation | Cost | Notes |
|-----------|------|-------|
| Atom creation | ~100 | Heap allocation + initialization |
| List traversal | ~10/node | Pointer following |
| Truth value calc | ~50 | Floating point ops |
| Module call | ~20 | Indirect function call |
| Pattern match | O(n) | Linear search |

### Optimization Strategies

1. **Batch Operations**: Group related ops to reduce overhead
2. **List Reuse**: Avoid unnecessary list creation
3. **Inline Helpers**: Small functions inlined by compiler
4. **Type Assertions**: Help compiler optimize

### Example Optimization

Before:
```limbo
for (l := atoms; l != nil; l = tl l) {
    atom := hd l;
    if (match(atom))
        result = atom :: result;
}
```

After (pre-allocate):
```limbo
result: list of ref Atom = nil;
count := 0;
for (l := atoms; l != nil; l = tl l) {
    atom := hd l;
    if (match(atom)) {
        result = atom :: result;
        count++;
    }
}
```

## Concurrency Support

### Channels

Dis VM provides CSP-style channels:

```limbo
chan_atoms := chan of ref Atom;

# Send
chan_atoms <-= atom;

# Receive
atom := <-chan_atoms;
```

### Threads

Spawn lightweight threads:

```limbo
spawn process_atoms(chan_atoms);
```

### OpenCog Integration

For distributed reasoning:

```limbo
# Producer thread
spawn {
    for (l := atoms; l != nil; l = tl l)
        result_chan <-= process(hd l);
};

# Consumer thread
spawn {
    while (atom := <-result_chan)
        handle_result(atom);
};
```

## Cross-Platform Compatibility

### Native Platforms

Dis VM runs natively on:
- x86 (32/64-bit)
- ARM
- PowerPC
- MIPS

### Hosted Environments

Runs hosted on:
- Linux (emu)
- Windows (emu)
- macOS (emu)
- Plan 9

### Bytecode Portability

`.dis` files are platform-independent:
- Same bytecode runs everywhere
- No recompilation needed
- Binary compatibility guaranteed

## Debugging

### Symbol Tables

Compile with `-g` for debugging:

```sh
limbo -g -w atomspace.b
```

Generates `atomspace.sbl` with:
- Line number mapping
- Variable names
- Type information

### Runtime Checks

Enable runtime checking:

```sh
limbo -gw atomspace.b
```

Checks for:
- Nil pointer dereference
- Array bounds
- Type violations

### Print Debugging

```limbo
sys->print(sys->sprint("Atom %d: %s\n", atom.id, atom.name));
```

### Memory Inspection

```sh
# In Inferno shell
cat /prog/PID/heap
cat /prog/PID/stack
```

## Integration with Inferno Services

### Namespace

Access via standard namespace:

```limbo
sys->bind("#U", "/dev", Sys->MBEFORE);
```

### 9P Protocol

Export services via 9P:

```limbo
# Serve AtomSpace over network
styxservers->serve(fd, atomspace_server);
```

### Styx Protocol

```limbo
# Mount remote AtomSpace
sys->mount(fd, nil, "/n/remote", Sys->MREPL, nil);
```

## Best Practices

### Module Design

1. **Keep interfaces small**: Minimal exported functions
2. **Use ADTs**: Encapsulate data structures
3. **Version carefully**: PATH constant indicates compatibility

### Error Handling

```limbo
atom := getatom(handle, id);
if (atom == nil) {
    sys->print("Error: atom not found\n");
    return;
}
```

### Resource Management

```limbo
# Initialization
cogsys := opencog->init();

# Use resources
# ...

# Always cleanup
opencog->shutdown(cogsys);
cogsys = nil;  # Allow GC
```

### Performance

1. Avoid repeated module loads
2. Cache frequently-used atoms
3. Use appropriate data structures
4. Profile with /prog/PID/profile

## Limitations

### Current Limitations

1. **No persistence**: Atoms lost on exit
2. **Single-threaded**: Basic implementation
3. **Memory-bound**: No external storage
4. **Linear search**: No indexing structures

### Future Work

1. **Styx integration**: Persistent storage
2. **Distributed processing**: Multi-node reasoning
3. **Hash tables**: O(1) lookup
4. **B-trees**: Sorted atom access

## References

### Dis VM Specification

- Inferno Dis VM Specification
- Limbo Language Reference
- Inferno System Module Documentation

### OpenCog

- OpenCog AtomSpace documentation
- PLN specification
- Cognitive architecture papers

## Appendix: Bytecode Example

Sample disassembly of compiled function:

```
addatom:
0:  frame    16          # Allocate stack frame
1:  movw    $1, 12(fp)   # atom.id = nextid
2:  new     Atom, r0     # Allocate Atom
3:  movp    r0, 8(fp)    # Store reference
4:  addw    $1, $1, r1   # nextid++
5:  ret                  # Return
```

Each instruction executes in constant time on the Dis VM.
