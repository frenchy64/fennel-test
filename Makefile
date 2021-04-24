.PHONY: help doc

doc:
	fenneldoc test.fnl

help:
	@echo "make doc  -- create documentation with fenneldoc" >&2
	@echo "make help -- print this message and exit" >&2
