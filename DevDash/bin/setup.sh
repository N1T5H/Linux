#!/bin/bash

# DevDash Setup Script
# This script initializes a new project setup by creating a Git repository and standard project folders.

init_git() {
    git init
    echo "Git repository initialized."
}

create_project_structure() {
    mkdir -p src tests docs
    echo "Project structure created: src, tests, and docs directories."
}

main() {
    init_git
    create_project_structure
}

# Run the main setup process
main
