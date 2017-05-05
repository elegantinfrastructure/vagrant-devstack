export OS_RELEASE ?= ocata
export GIT_BASE ?= https://github.com

default: build package

build: clean
	vagrant up

package:
	vagrant package
	vagrant box add --force --name devstack-$(OS_RELEASE) package.box

clean:
	vagrant destroy -f
	rm -f package.box
