noargs:
	@echo "usage: make encode/decode/diff/copy ARGS=\"various required args\""
encode:
	processing-java --sketch=image_processing/image_encoder --run $(ARGS)
	cp image_processing/image_encoder/encoded.png image_processing/image_diff/
	cp image_processing/image_encoder/encoded.png image_processing/image_decoder/

	processing-java --sketch=audio_processing/audio_encoder --run $(ARGS)
	cp audio_processing/audio_encoder/output.wav audio_output/
decode:
	processing-java --sketch=image_processing/image_decoder --run $(ARGS)
	cp image_processing/image_encoder/output.png image_processing/image_diff/
	cp image_processing/image_encoder/encoded.png image_processing/image_decoder/
diff:
	processing-java --sketch=image_processing/image_diff --run $(ARGS)
copy:
	@echo "Copy commands are integrated into encode and decode steps."
