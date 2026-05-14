#!/usr/bin/env python3
"""
DMS File Lister - List directories and search files for markdown viewer plugin
"""

import os
import json
import sys
from pathlib import Path

def expand_path(path):
    """Expand ~ to home directory"""
    if path.startswith("~"):
        return os.path.expanduser(path)
    return path

def list_directory(dir_path):
    """List files and directories in a given path"""
    expanded = expand_path(dir_path)
    
    try:
        entries = os.listdir(expanded)
    except Exception as e:
        return None, f"failed to read directory: {e}"
    
    files = []
    for entry in entries:
        # Skip hidden files/dirs
        if entry.startswith('.'):
            continue
            
        full_path = os.path.join(expanded, entry)
        is_dir = os.path.isdir(full_path)
        
        files.append({
            "name": entry,
            "path": full_path,
            "isDir": is_dir
        })
    
    # Sort by name, directories first
    files.sort(key=lambda x: (not x["isDir"], x["name"].lower()))
    return files, None

def fuzzy_search(files, query):
    """Simple fuzzy search - match query chars in order"""
    if not query or not query.strip():
        return files
    
    query = query.lower()
    results = []
    
    for f in files:
        name = f["name"].lower()
        
        # Exact substring match (highest priority)
        if query in name:
            results.append((f, 3))
        # All chars in order (fuzzy match)
        elif all(c in name for c in query):
            results.append((f, 2))
        # Starts with query
        elif name.startswith(query):
            results.append((f, 4))
    
    # Sort by priority (descending) then by name
    results.sort(key=lambda x: (-x[1], x[0]["name"].lower()))
    return [f for f, _ in results]

def search_markdown_files(dir_path, query=""):
    """Search for markdown files in directory"""
    expanded = expand_path(dir_path)
    markdown_files = []
    
    try:
        for entry in os.listdir(expanded):
            if entry.startswith('.'):
                continue
            
            full_path = os.path.join(expanded, entry)
            
            # Include markdown files and directories
            if entry.lower().endswith(('.md', '.markdown')):
                markdown_files.append({
                    "name": entry,
                    "path": full_path,
                    "isDir": False,
                    "type": "markdown"
                })
            elif os.path.isdir(full_path):
                markdown_files.append({
                    "name": entry,
                    "path": full_path,
                    "isDir": True,
                    "type": "directory"
                })
    except Exception as e:
        return None, f"failed to search: {e}"
    
    # Apply fuzzy search if query provided
    if query and query.strip():
        markdown_files = fuzzy_search(markdown_files, query)
    
    # Sort directories first, then files
    markdown_files.sort(key=lambda x: (not x["isDir"], x["name"].lower()))
    
    return markdown_files, None

def get_file_content(file_path):
    """Read file content safely"""
    expanded = expand_path(file_path)
    
    try:
        with open(expanded, 'r', encoding='utf-8', errors='replace') as f:
            return f.read(), None
    except Exception as e:
        return None, f"failed to read file: {e}"

def main():
    if len(sys.argv) < 2:
        result = {
            "files": [],
            "error": "no command provided"
        }
        print(json.dumps(result))
        sys.exit(1)
    
    command = sys.argv[1]
    
    # List directory command
    if command == "list" and len(sys.argv) >= 3:
        dir_path = sys.argv[2]
        files, err = list_directory(dir_path)
        
        if err:
            result = {"files": [], "error": err}
        else:
            result = {"files": files}
        
        print(json.dumps(result))
    
    # Search markdown files command
    elif command == "search" and len(sys.argv) >= 3:
        dir_path = sys.argv[2]
        query = sys.argv[3] if len(sys.argv) > 3 else ""
        
        files, err = search_markdown_files(dir_path, query)
        
        if err:
            result = {"files": [], "error": err}
        else:
            result = {"files": files}
        
        print(json.dumps(result))
    
    # Get file content command
    elif command == "read" and len(sys.argv) >= 3:
        file_path = sys.argv[2]
        content, err = get_file_content(file_path)
        
        if err:
            result = {"content": "", "error": err}
        else:
            result = {"content": content}
        
        print(json.dumps(result))
    
    else:
        result = {
            "error": "invalid command. usage: dms-file-lister [list|search|read] <path> [query]"
        }
        print(json.dumps(result))
        sys.exit(1)

if __name__ == "__main__":
    main()
