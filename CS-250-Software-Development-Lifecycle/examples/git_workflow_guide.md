# CS-250 Git & GitHub Workflow Guide

## 🎯 Purpose
Complete guide for version control, Git workflows, and collaborative development practices used in software development lifecycle.

## 🔧 Git Setup & Configuration

### Initial Setup
```bash
# Install Git
# Windows: https://git-scm.com/download/win
# Mac: brew install git
# Linux: sudo apt install git

# Configure Git globally
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Set default branch name
git config --global init.defaultBranch main

# Set default editor
git config --global core.editor "code --wait"

# Verify configuration
git config --list
```

### SSH Key Setup
```bash
# Generate SSH key
ssh-keygen -t ed25519 -C "your.email@example.com"

# Add SSH key to ssh-agent
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# Copy public key to clipboard
# Windows
clip < ~/.ssh/id_ed25519.pub

# Mac
pbcopy < ~/.ssh/id_ed25519.pub

# Linux
cat ~/.ssh/id_ed25519.pub
```

**Add SSH key to GitHub:**
1. Go to GitHub Settings → SSH and GPG keys
2. Click "New SSH key"
3. Paste your public key
4. Give it a descriptive title

## 📚 Essential Git Commands

### Basic Workflow
```bash
# Initialize repository
git init

# Clone existing repository
git clone https://github.com/username/repository.git
git clone git@github.com:username/repository.git  # SSH

# Check status
git status

# Add files to staging
git add filename.txt
git add .  # Add all files
git add *.js  # Add all JS files

# Commit changes
git commit -m "Add initial project setup"
git commit -am "Update README and fix bug"  # Add and commit

# View commit history
git log
git log --oneline  # Compact view
git log --graph --oneline --all  # Visual graph

# View changes
git diff  # Working directory vs staging
git diff --staged  # Staging vs last commit
git diff HEAD~1  # Compare with previous commit
```

### Branching & Merging
```bash
# List branches
git branch
git branch -a  # Include remote branches

# Create and switch to new branch
git checkout -b feature/new-feature
git switch -c feature/new-feature  # Newer syntax

# Switch between branches
git checkout main
git switch main  # Newer syntax

# Merge branch
git checkout main
git merge feature/new-feature

# Delete branch
git branch -d feature/new-feature  # Local
git push origin --delete feature/new-feature  # Remote
```

### Remote Operations
```bash
# Add remote repository
git remote add origin https://github.com/username/repository.git

# List remotes
git remote -v

# Fetch changes from remote
git fetch origin

# Pull changes
git pull origin main
git pull --rebase origin main  # Rebase instead of merge

# Push changes
git push origin main
git push -u origin feature-branch  # Set upstream

# Push all branches
git push --all origin
```

## 🔄 Git Workflow Strategies

### Git Flow (Feature Branch Workflow)
```bash
# Main branches
main          # Production-ready code
develop       # Integration branch for features

# Supporting branches
feature/*     # New features
release/*     # Prepare new release
hotfix/*      # Critical bug fixes

# Example workflow
git checkout develop
git pull origin develop
git checkout -b feature/user-authentication
# ... work on feature ...
git add .
git commit -m "Add user authentication"
git push origin feature/user-authentication
# Create Pull Request
# After review and merge:
git checkout develop
git pull origin develop
git branch -d feature/user-authentication
```

### GitHub Flow (Simplified)
```bash
# Single main branch
main          # Production-ready code

# Feature branches
feature/*     # New features and bug fixes

# Example workflow
git checkout main
git pull origin main
git checkout -b feature/add-login
# ... work on feature ...
git add .
git commit -m "Add login functionality"
git push origin feature/add-login
# Create Pull Request
# After review and merge:
git checkout main
git pull origin main
git branch -d feature/add-login
```

### GitLab Flow (Environment-based)
```bash
# Branches
main          # Production
staging       # Pre-production testing
develop       # Development integration

# Example workflow
git checkout develop
git pull origin develop
git checkout -b feature/payment-integration
# ... work on feature ...
git add .
git commit -m "Add payment integration"
git push origin feature/payment-integration
# Create Merge Request to develop
# After testing, merge to staging
# After staging approval, merge to main
```

## 🤝 Collaborative Development

### Pull Request Workflow
```bash
# 1. Fork repository (on GitHub)
# 2. Clone your fork
git clone https://github.com/yourusername/repository.git
cd repository

# 3. Add upstream remote
git remote add upstream https://github.com/originalowner/repository.git

# 4. Create feature branch
git checkout -b feature/your-feature
# ... make changes ...
git add .
git commit -m "Add your feature"
git push origin feature/your-feature

# 5. Create Pull Request on GitHub
# 6. After PR is merged, clean up
git checkout main
git pull upstream main
git push origin main
git branch -d feature/your-feature
```

### Code Review Process
```bash
# Review changes
git fetch origin
git checkout feature/under-review
git diff main..feature/under-review

# Test the changes
npm test
npm run lint

# Add review comments
# Approve or request changes
# Merge after approval
```

### Resolving Conflicts
```bash
# When merge conflicts occur
git status  # See conflicted files
# Edit files to resolve conflicts
# Remove conflict markers (<<<<<<< ======= >>>>>>>)
git add resolved-file.txt
git commit -m "Resolve merge conflict in resolved-file.txt"

# For rebase conflicts
git rebase --continue  # After resolving
git rebase --abort     # To cancel rebase
```

## 🛠️ Advanced Git Techniques

### Interactive Rebase
```bash
# Rebase last 3 commits
git rebase -i HEAD~3

# Commands in interactive rebase:
# pick    - use commit
# reword  - use commit, but edit message
# edit    - use commit, but stop for amending
# squash  - use commit, but meld into previous
# drop    - remove commit

# Example: Squash commits
pick a1b2c3d Add user model
squash d4e5f6g Add user validation
squash h7i8j9k Add user tests
```

### Stashing
```bash
# Save work in progress
git stash
git stash push -m "Work in progress on feature X"

# List stashes
git stash list

# Apply stash
git stash apply
git stash pop  # Apply and remove

# Apply specific stash
git stash apply stash@{0}

# Drop stash
git stash drop stash@{0}
```

### Cherry-picking
```bash
# Apply specific commit to current branch
git cherry-pick commit-hash

# Cherry-pick range
git cherry-pick start-commit..end-commit

# Cherry-pick with no commit
git cherry-pick --no-commit commit-hash
```

### Submodules
```bash
# Add submodule
git submodule add https://github.com/user/repo.git path/to/submodule

# Clone repository with submodules
git clone --recursive https://github.com/user/repo.git

# Update submodules
git submodule update --init --recursive
```

## 📋 Git Hooks

### Pre-commit Hook
```bash
# Create pre-commit hook
cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash
# Run tests before commit
npm test
if [ $? -ne 0 ]; then
    echo "Tests failed. Commit aborted."
    exit 1
fi

# Run linter
npm run lint
if [ $? -ne 0 ]; then
    echo "Linting failed. Commit aborted."
    exit 1
fi
EOF

chmod +x .git/hooks/pre-commit
```

### Commit Message Template
```bash
# Set commit message template
git config commit.template .gitmessage

# Create template
cat > .gitmessage << 'EOF'
# <type>(<scope>): <subject>
#
# <body>
#
# <footer>
#
# Types: feat, fix, docs, style, refactor, test, chore
# Scope: component, module, or file
# Subject: imperative mood, lowercase, no period
# Body: explain what and why, not how
# Footer: breaking changes, issues closed
EOF
```

## 🔍 Git Debugging & Maintenance

### Finding Issues
```bash
# Find when bug was introduced
git bisect start
git bisect bad HEAD
git bisect good commit-hash
# Test current commit, then:
git bisect good  # or git bisect bad
# Repeat until found

# Find large files
git rev-list --objects --all | git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' | sed -n 's/^blob //p' | sort --numeric-sort --key=2 | tail -10

# Find commit that changed specific line
git blame filename.txt
git log -L 10,20:filename.txt
```

### Repository Maintenance
```bash
# Clean up repository
git gc  # Garbage collection
git prune  # Remove unreachable objects

# Remove sensitive data
git filter-branch --force --index-filter 'git rm --cached --ignore-unmatch path/to/sensitive/file' --prune-empty --tag-name-filter cat -- --all

# Update remote references
git remote prune origin
```

## 🚀 GitHub Features

### GitHub Actions (CI/CD)
```yaml
# .github/workflows/ci.yml
name: CI

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Node.js
      uses: actions/setup-node@v3
      with:
        node-version: '18'
        
    - name: Install dependencies
      run: npm ci
      
    - name: Run tests
      run: npm test
      
    - name: Run linter
      run: npm run lint
```

### GitHub Pages
```bash
# Enable GitHub Pages
# Settings → Pages → Source: Deploy from branch
# Select main branch and /docs folder

# Create documentation
mkdir docs
echo "# Project Documentation" > docs/index.md
git add docs/
git commit -m "Add documentation"
git push origin main
```

### GitHub Issues & Projects
```bash
# Link commits to issues
git commit -m "Fix user authentication (#123)"

# Close issues with commit
git commit -m "Add user validation

Closes #123
Fixes #456"
```

## 📚 Learning Resources

### Git Documentation
- **Pro Git Book**: https://git-scm.com/book
- **GitHub Docs**: https://docs.github.com/
- **Atlassian Git Tutorials**: https://www.atlassian.com/git/tutorials
- **Learn Git Branching**: https://learngitbranching.js.org/

### Interactive Learning
- **GitHub Learning Lab**: https://lab.github.com/
- **Oh My Git!**: https://ohmygit.org/
- **GitKraken Learn**: https://www.gitkraken.com/learn/git

### Best Practices
- **Conventional Commits**: https://www.conventionalcommits.org/
- **Semantic Versioning**: https://semver.org/
- **Keep a Changelog**: https://keepachangelog.com/

## 🎯 CS-250 Project Checklist

### Phase 1: Repository Setup
- [ ] Initialize Git repository
- [ ] Configure Git settings
- [ ] Set up SSH keys
- [ ] Create GitHub repository
- [ ] Add remote origin

### Phase 2: Development Workflow
- [ ] Create main and develop branches
- [ ] Set up branch protection rules
- [ ] Configure pre-commit hooks
- [ ] Create commit message template

### Phase 3: Collaboration
- [ ] Set up team access
- [ ] Create issue templates
- [ ] Configure pull request templates
- [ ] Set up code review process

### Phase 4: CI/CD
- [ ] Set up GitHub Actions
- [ ] Configure automated testing
- [ ] Set up deployment pipeline
- [ ] Monitor build status

### Phase 5: Documentation
- [ ] Create README.md
- [ ] Document setup process
- [ ] Create contributing guidelines
- [ ] Set up GitHub Pages

## 💡 Pro Tips

1. **Commit Often**: Make small, frequent commits
2. **Write Good Messages**: Use conventional commit format
3. **Review Before Push**: Always review changes before pushing
4. **Use Branches**: Keep features isolated in branches
5. **Clean History**: Use interactive rebase to clean up commits
6. **Backup Important Work**: Push to remote regularly
7. **Use .gitignore**: Exclude unnecessary files
8. **Document Changes**: Update documentation with code changes
9. **Test Before Commit**: Run tests before committing
10. **Learn Git Internals**: Understanding Git helps with complex scenarios
