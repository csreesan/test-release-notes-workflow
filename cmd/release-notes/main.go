package main

import (
	"io"
	"os"
	"path"
)

var (
	cliName = "confluent"
)


func main() {

	fileName := path.Join(".", "release-notes", cliName, "index.rst")

	err := writeReleaseNotes(fileName)
	if err != nil {
		panic(err)
	}
}

func writeReleaseNotes(filename string) error {
	content := `

|ccloud| CLI Release Notes
==============================

The available |ccloud| CLI release notes are documented here.

`
	f, err := os.Create(filename)
	if err != nil {
		return err
	}
	defer f.Close()
	_, err = io.WriteString(f, content)
	return err
}