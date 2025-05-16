noargs:
	@echo "usage: make encode/decode/diff/copy ARGS=\"various required args\""
decode:
	processing-java --sketch=image_processing/image_decoder --run $(ARGS)
	cp image_processing/image_encoder/output.png ../image_diff
	cp image_processing/image_encoder/encoded.png ../image_encoder
encode:
	processing-java --sketch=image_processing/image_encoder --run $(ARGS)
	cp image_processing/image_encoder/encoded.png ../image_diff
	cp image_processing/image_encoder/encoded.png ../image_decoder
diff:
	processing-java --sketch=image_processing/image_diff --run $(ARGS)
