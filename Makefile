
build:
	docker build --no-cache --pull -t my-lsio-plex .

.PHONY: diffnew
diffnew:
	git remote update
	git log1 master...upstream/master
