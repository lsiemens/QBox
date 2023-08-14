# run jekyll server localy to the adress localhost:4000
all:
	bundle exec jekyll serve

# include drafts in the compiled website
draft:
	bundle exec jekyll serve --drafts

gem_update:
	bundle update
	bundle install

# get documentation from main branch
get_documentation:
	git fetch
	git checkout origin/master -- Documentation
	cd ./Documentation && ./makeDocumentation.py
