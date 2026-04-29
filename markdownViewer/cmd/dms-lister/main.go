package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"os"
	"path/filepath"
	"sort"
	"strings"
)

type FileEntry struct {
	Name  string `json:"name"`
	Path  string `json:"path"`
	IsDir bool   `json:"isDir"`
}

type ListResult struct {
	Files []FileEntry `json:"files"`
	Error string      `json:"error,omitempty"`
}

func expandPath(path string) (string, error) {
	if strings.HasPrefix(path, "~") {
		home, err := os.UserHomeDir()
		if err != nil {
			return "", err
		}
		return filepath.Join(home, path[1:]), nil
	}
	return path, nil
}

func listDirectory(dirPath string) ([]FileEntry, error) {
	// Expand ~ if present
	expanded, err := expandPath(dirPath)
	if err != nil {
		return nil, fmt.Errorf("failed to expand path: %w", err)
	}

	// Read directory
	entries, err := os.ReadDir(expanded)
	if err != nil {
		return nil, fmt.Errorf("failed to read directory: %w", err)
	}

	var files []FileEntry

	for _, entry := range entries {
		name := entry.Name()
		filePath := filepath.Join(expanded, name)
		isDir := entry.IsDir()

		files = append(files, FileEntry{
			Name:  name,
			Path:  filePath,
			IsDir: isDir,
		})
	}

	// Sort by name
	sort.Slice(files, func(i, j int) bool {
		return files[i].Name < files[j].Name
	})

	return files, nil
}

func main() {
	flag.Parse()

	if flag.NArg() < 1 {
		result := ListResult{
			Files: []FileEntry{},
			Error: "no directory path provided",
		}
		json.NewEncoder(os.Stdout).Encode(result)
		os.Exit(1)
	}

	dirPath := flag.Arg(0)

	files, err := listDirectory(dirPath)
	if err != nil {
		result := ListResult{
			Files: []FileEntry{},
			Error: err.Error(),
		}
		json.NewEncoder(os.Stdout).Encode(result)
		os.Exit(1)
	}

	result := ListResult{
		Files: files,
	}

	json.NewEncoder(os.Stdout).Encode(result)
}
