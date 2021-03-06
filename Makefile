

build:
	$(MAKE) -C apt-hook build

deps:
	./dev/read-dependencies -v 3 --system-pkg-names --test-distro

clean:
	rm -f *.build *.buildinfo *.changes .coverage *.deb *.dsc *.tar.gz *.tar.xz
	rm -rf *.egg-info/ .tox/ .cache/
	find . -type f -name '*.pyc' -delete
	find . -type d -name '*__pycache__' -delete
	$(MAKE) -C apt-hook clean

deb:
	@echo Building unsigned debian package
	@which dpkg-buildpackage || \
               { echo -e "Missing build dependencies. Install with:" \
                 "\n make deps"; exit 1; }
	./dev/bddeb

test:
	@tox

testdeps:
	pip install tox


.PHONY: build deps clean deb test testdeps
