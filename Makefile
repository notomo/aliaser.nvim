test:
	vusted --shuffle
.PHONY: test

doc:
	rm -f ./doc/aliaser.nvim.txt ./README.md
	nvim --headless -i NONE -n +"lua dofile('./spec/lua/aliaser/doc.lua')" +"quitall!"
	cat ./doc/aliaser.nvim.txt ./README.md
.PHONY: doc
