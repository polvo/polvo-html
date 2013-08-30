MVERSION=node_modules/mversion/bin/version
CS=node_modules/coffee-script/bin/coffee
VERSION=`$(MVERSION) | sed -E 's/\* package.json: //g'`


setup:
	@npm install



watch:
	@$(CS) -bwmco lib src

build:
	@$(CS) -bcmo lib src



bump.minor:
	@$(MVERSION) minor

bump.major:
	@$(MVERSION) major

bump.patch:
	@$(MVERSION) patch



publish:
	git tag $(VERSION)
	git push origin $(VERSION)
	git push origin master
	npm publish

re-publish:
	git tag -d $(VERSION)
	git tag $(VERSION)
	git push origin :$(VERSION)
	git push origin $(VERSION)
	git push origin master -f
	npm publish -f