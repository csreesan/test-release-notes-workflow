package main

import (
	"fmt"
	"io"
	"os"
	"path"
	"strings"
)

var (
	cliName = "confluent"
	version = "V1.0.0"
)


func main() {

	fileName := path.Join(".", "release-notes", cliName, "index.rst")

	err := writeReleaseNotes(fileName, cliName, version)
	if err != nil {
		panic(err)
	}
}

func writeReleaseNotes(filename string, cliName string, version string) error {
	content := `

%s CLI %s Release Notes
==============================

New Features
- new feature


Bug Fixes
- bug
`
	f, err := os.Create(filename)
	if err != nil {
		return err
	}
	defer f.Close()
	_, err = io.WriteString(f, fmt.Sprintf(content, strings.ToUpper(cliName), version))
	return err
}