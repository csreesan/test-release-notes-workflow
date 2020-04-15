SHELL := /bin/bash
# @ sign just suppress the echo of the command
# $$ is basically just passing $ to the shell
# if you want the shell to expand a variable, rather than having the makefile do it you need to escape $ by using $$
# cd - goes back to where you previously were

# sed = stream editor, has many commands but most people use s (substituion) sed s/day/night/ old >new changes "day" in the old file to night in the new file
# echo day | sed s/day/night/
# echo "day day bob day" | sed s/day/night/g
# -i = --in-place = in-place argument

# command1 && command2 makes sure that command2 isn't run if there's an error in the first command

CLI_NAME := ccloud
DOCS_BRANCH := master
VERSION := $(shell git rev-parse --is-inside-work-tree > /dev/null && git describe --tags)

.PHONY: release-notes
release-notes:
	@GO11MODULE=on go run -ldflags '-X main.cliName=ccloud -X main.version=$(VERSION)' cmd/release-notes/main.go



.PHONY: publish-release-notes
publish-release-notes: release-notes
	@TMP_BASE=$$(mktemp -d) || exit 1; \
		TMP_DIR=$${TMP_BASE}/release-notes; \
		git clone git@github.com:csreesan/test-release-notes.git $${TMP_DIR}; \
		cd $${TMP_DIR} || exit 1; \
		ls; \
		git fetch ; \
		git checkout -b cli-$(VERSION) origin/$(DOCS_BRANCH) || exit 1; \
		cd - || exit 1; \
		make publish-release-notes-internal BASE_DIR=$${TMP_DIR} CLI_NAME=ccloud || exit 1; \
		cd $${TMP_DIR} || exit 1; \
		git add . || exit 1; \
		git diff --cached --exit-code > /dev/null && echo "nothing to update" && exit 0; \
		git commit -m "[WIP] new release notes for $(VERSION)" || exit 1; \
		git push origin cli-$(VERSION) || exit 1; \
		hub pull-request -b $(DOCS_BRANCH) -m "new release notes for $(VERSION)" || exit 1; \
		rm -rf $${TMP_BASE}; \
		echo "GOT TO THE END $${TMP_DIR}"

.PHONY: publish-release-notes-internal
publish-release-notes-internal:
ifndef BASE_DIR
	$(error BASE_DIR is not set)
endif 
ifeq (ccloud,$(CLI_NAME))
	$(eval RELEASE_DIR := cloud/cli/release-notes)
endif
	rm $(BASE_DIR)/$(RELEASE_DIR)/*.rst
	cp release-notes/$(CLI_NAME)/*.rst $(BASE_DIR)/$(RELEASE_DIR)

.PHONY: clean-releases
clean-releases:
	rm release-notes/*/*.rst


no-dub:
	for i in a b c d; do echo $i; done

dub:
	for i in a b c d; do echo $$i; done




# help - The default goal 
.PHONY: help 
help: 
	# can actually just use make in place of $(MAKE)
	@$(MAKE) --print-data-base --question |\
	awk '/^[^.%][-A-Za-z0-9_]*:/ { print substr($$1, 1, length($$1)-1) }' |\
	sort



.PHONY:
lands:
	ls
	# built-in make functions terminate command parsing mode unless proceeded by a tab character
	# so they either have to expand to valid shell or to nothing or else we get an error
	$(shell ls > /dev/null)
	# passed first one
	$(shell ls)
