PACKAGE=termpix
PRGNAME=termpix.py
VERSION := $(shell grep '^__version__ = ' $(PACKAGE)/$(PRGNAME) | awk -F\" '{print $$2}')
SETUPFILE=setup.py

create:
	@sed -i -e 's/^version = ".*"/version = "$(VERSION)"/g' $(SETUPFILE)
	python $(SETUPFILE) sdist bdist_wheel

# upload to testpypi
uptest:
	python -m twine upload --repository testpypi dist/*
# uninstall package and test APP
test:
	@echo $(VERSION)
	@#false
	@make uninstall
	pip --no-cache-dir install --index-url https://test.pypi.org/simple/ $(PACKAGE)==$(VERSION)
	@which $(PACKAGE)
	@make testapp
	

# upload to pypi
uppypi:
	python -m twine upload dist/*
# install the latest package
install:
	make uninstall
	pip --no-cache-dir install --index-url https://pypi.org/simple/ $(PACKAGE)==$(VERSION)

# test command
testapp:
	$(PACKAGE) https://img.blogs.es/anexom/wp-content/uploads/2020/10/mario-destacada_E.jpg --true-color

# uninstall package
uninstall:
	pip uninstall $(PACKAGE) -y
# clean up
clean:
	/bin/rm -rf dist/* build/*
