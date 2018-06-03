.PHONY: clean build push watch-server
export PATH := $(shell pwd)/bin:$(PATH)

watch-server:
	hugo server --bind=0.0.0.0 --watch

clean:
	test -z "$(shell git status --porcelain)" || ( echo 'uncommited changes!'; exit 1)
	rm public/* -rf

build: clean
	bin/check-guids && hugo

commit: build
	cd public && git add -Af . && git ci -m 'derp' || true

push: commit | public
	git push
	cd public && git push origin HEAD:gh-pages -f

public: | public/.git

public/.git:
	git init public
	cd public && git remote add origin gh:frioux/clog
