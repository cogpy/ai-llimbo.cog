# Mercurial Integration Guide

## Overview

This OpenCog Inferno implementation uses Mercurial (hg) for version control, providing distributed development capabilities compatible with Inferno's philosophy.

## Why Mercurial?

Mercurial aligns with Inferno's design principles:

1. **Written in Python**: Portable and maintainable
2. **Distributed**: No central server required
3. **Simple**: Clean command structure
4. **Efficient**: Fast operations on large codebases
5. **Cross-platform**: Runs on all Inferno-supported systems

## Repository Structure

```
.hg/
├── hgrc              # Repository configuration
├── store/            # Object database
│   ├── 00changelog.i # Changelog index
│   ├── 00manifest.i  # Manifest index
│   └── data/         # File data
├── dirstate          # Working directory state
└── branch            # Current branch name

.hgignore             # Ignore patterns
```

## Configuration

### Repository Config (.hg/hgrc)

```ini
[ui]
username = OpenCog Inferno Developer <dev@opencog-inferno.org>
ignore = ~/.hgignore

[extensions]
color =         # Colored output
pager =         # Paged output
progress =      # Progress bars
rebase =        # Rebase support

[alias]
log-graph = log --graph --template '{node|short} {desc|firstline}\n'
st = status
ci = commit
co = checkout

[paths]
default = /n/remote/opencog-inferno

[hooks]
precommit.build = mk clean && mk all

[merge-tools]
vimdiff.executable = acme
vimdiff.args = -d $local $other
```

### Global Config (~/.hgrc)

```ini
[ui]
username = Your Name <you@example.com>
editor = acme

[extensions]
color =
progress =
pager =

[pager]
pager = less -FRX
attend = diff, log, glog, status

[color]
mode = auto
```

### Ignore Patterns (.hgignore)

```
syntax: glob

# Dis bytecode
*.dis
*.sbl

# Build artifacts
*.o
*.a

# Editor backups
*~
*.swp
*.bak

# Temp files
/tmp/*
*.tmp
*.log

# OS specific
.DS_Store
Thumbs.db
```

## Workflow

### Initial Setup

```sh
# Initialize repository
cd /usr/inferno/appl/opencog-inferno
hg init

# Add files
hg add module/*.m
hg add appl/*.b
hg add mkfile
hg add README.md

# First commit
hg commit -m "Initial OpenCog Inferno implementation"
```

### Daily Workflow

```sh
# Check status
hg status
# or using alias
hg st

# See changes
hg diff

# Add new files
hg add newfile.b

# Commit
hg commit -m "Add feature X"
# or using alias
hg ci -m "Add feature X"

# View history
hg log
# or graph view
hg log-graph
```

### Branching

```sh
# Create branch
hg branch feature-x

# List branches
hg branches

# Switch branch
hg update feature-x

# Merge branch
hg update default
hg merge feature-x
hg commit -m "Merge feature-x"
```

### Remote Operations

```sh
# Clone repository
hg clone /n/remote/opencog-inferno local-copy

# Pull changes
hg pull

# Update working directory
hg update

# Push changes
hg push

# Push to specific location
hg push /n/backup/opencog-inferno
```

## Pre-commit Hooks

### Build Verification

The pre-commit hook ensures code builds:

```sh
precommit.build = mk clean && mk all
```

This runs before each commit:
1. Cleans build artifacts
2. Rebuilds all modules
3. Fails commit if build fails

### Custom Hooks

Add additional hooks:

```ini
[hooks]
# Ensure modules compile
precommit.modules = mk modules

# Run tests
precommit.test = mk test

# Check formatting
precommit.style = sh check-style.sh
```

## Integration with Inferno

### Namespace Access

Mount remote repository via 9P:

```sh
# Mount remote repository
mount -A tcp!remote!9fs /n/remote

# Clone from mounted namespace
hg clone /n/remote/opencog-inferno local
```

### File Server

Serve repository via Inferno's file protocol:

```sh
# Start file server
styxlisten -A 'tcp!*!9fs' export /usr/inferno/appl/opencog-inferno
```

### Remote Development

```sh
# On development machine
hg push /n/remote/repo

# On build machine (auto-mounted)
hg pull /n/build/repo
hg update
mk all
```

## Distributed Development

### Clone and Diverge

```sh
# Developer A clones
hg clone /n/central/opencog-inferno dev-a

# Developer B clones
hg clone /n/central/opencog-inferno dev-b

# Both make changes independently
cd dev-a
# ... make changes ...
hg commit -m "Feature A"

cd ../dev-b
# ... make changes ...
hg commit -m "Feature B"
```

### Merge Workflow

```sh
# Developer A pushes first
cd dev-a
hg push /n/central/opencog-inferno

# Developer B pulls and merges
cd ../dev-b
hg pull /n/central/opencog-inferno
hg merge
hg commit -m "Merge with feature A"
hg push /n/central/opencog-inferno
```

## Conflict Resolution

### Using Acme

Configured as default merge tool:

```sh
# Conflict occurs during merge
hg merge
# Acme opens with:
# - Left pane: local version
# - Right pane: remote version

# Edit to resolve
# Save and exit Acme

# Mark resolved
hg resolve --mark conflicted-file.b

# Complete merge
hg commit -m "Merge with conflict resolution"
```

### Manual Resolution

```sh
# List conflicts
hg resolve --list

# Edit files manually
acme module/atomspace.m

# Mark resolved
hg resolve --mark module/atomspace.m

# Verify all resolved
hg resolve --list

# Commit
hg commit -m "Resolved merge conflicts"
```

## Advanced Usage

### Rebase

```sh
# Enable in .hgrc
[extensions]
rebase =

# Rebase current branch
hg rebase -d default
```

### History Editing

```sh
# Enable extensions
[extensions]
histedit =
strip =

# Edit history (interactive)
hg histedit

# Remove changeset
hg strip REV
```

### Bisect

```sh
# Find bug introduction
hg bisect --reset
hg bisect --bad
hg bisect --good REV

# Test each revision
mk test
hg bisect --good  # or --bad

# Reset when done
hg bisect --reset
```

## Repository Maintenance

### Verify Integrity

```sh
# Check repository
hg verify

# Check specific revision
hg verify -r REV
```

### Cleanup

```sh
# Remove untracked files (dry run)
hg purge --print

# Actually remove
hg purge
```

### Backup

```sh
# Clone for backup
hg clone opencog-inferno opencog-inferno-backup

# Bundle for offline transfer
hg bundle --all backup.hg

# Restore from bundle
hg unbundle backup.hg
```

## Performance Tips

### Large Repositories

```sh
# Shallow clone (if supported)
hg clone --depth 1 source dest

# Clone specific branch
hg clone -b branch-name source dest
```

### Network Optimization

```sh
# Use compression
[ui]
ssh = ssh -C

# Bundle for slow connections
hg bundle changes.hg -r FROM:TO
# Transfer bundle via sneakernet
hg unbundle changes.hg
```

## Troubleshooting

### Common Issues

**Uncommitted changes**:
```sh
hg status
hg commit -m "Save work"
# or
hg stash
```

**Merge conflicts**:
```sh
hg resolve --list
# Edit files
hg resolve --mark file
hg commit -m "Merge"
```

**Corrupt repository**:
```sh
hg verify
hg recover
```

### Recovery

```sh
# Undo last commit (keep changes)
hg rollback

# Revert file to previous version
hg revert file.b

# Revert all changes
hg update -C
```

## Best Practices

### Commit Messages

```
Short summary (50 chars or less)

More detailed explanation if needed. Wrap at 72 characters.

- Bullet points are fine
- Use imperative mood: "Add feature" not "Added feature"

Fixes: #123
```

### Commit Frequency

- Commit working code frequently
- Each commit should build successfully
- Group related changes together

### Branch Strategy

```
default       - Stable, production-ready
develop       - Integration branch
feature-X     - Feature branches
hotfix-Y      - Bug fixes
```

## Integration Examples

### Automated Builds

```sh
#!/dis/sh
# build-on-commit.sh

hg pull
if { hg update } {
    mk clean
    mk all
    if { mk test } {
        echo Build successful
    } else {
        echo Tests failed
    }
} else {
    echo Update failed
}
```

### Continuous Integration

```sh
# Watch for changes
while true {
    hg pull -u
    if { hg tip --template '{node}' } != $LAST_BUILD {
        sh build-on-commit.sh
        LAST_BUILD=`{ hg tip --template '{node}' }
    }
    sleep 60
}
```

## References

- Mercurial Book: http://hgbook.red-bean.com/
- Inferno Namespace: Inferno Programmer's Manual
- 9P Protocol: Plan 9 Papers
- Distributed Development: Mercurial Guide

## Conclusion

Mercurial provides robust version control for OpenCog Inferno development, integrating seamlessly with Inferno's distributed namespace and file protocol. The pre-commit hooks ensure code quality, while the distributed nature enables flexible development workflows.
