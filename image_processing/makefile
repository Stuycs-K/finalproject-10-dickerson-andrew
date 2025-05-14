noargs:
	@echo "usage: make encode/decode/diff/copy ARGS=\"various required args\""
decode:
	processing-java --sketch=image_decoder --run $(ARGS)
encode:
	processing-java --sketch=image_encoder --run $(ARGS)
diff:
	processing-java --sketch=image_diff --run $(ARGS)
copy:
	cp ./image_encoder/$(ARGS) ./image_decoder/data/
