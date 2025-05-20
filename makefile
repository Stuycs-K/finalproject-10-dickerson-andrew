noargs:
	@echo "usage: make encode/decode/diff/copy ARGS=\"various required args\""

# Full Encoder - Finds an image hidden in an audio file, and then the message hidden in that image.
encode:
	processing-java --sketch=image_processing/image_encoder --run $(ARGS)
	processing-java --sketch=audio_processing/audio_encoder --run $(ARGS)

# Full Decoder - Finds an image hidden in an audio file, and then the message hidden in that image.
decode:
	processing-java --sketch=audio_processing/audio_decoder --run $(ARGS)
	processing-java --sketch=image_processing/image_decoder --run $(ARGS)

# Image Encoder - Hides message from plaintext or file in an image.
image_encode:
	processing-java --sketch=image_processing/image_encoder --run $(ARGS)

# Image Diff - Highlights differences between pixels in images.
image_diff:
	processing-java --sketch=image_processing/image_diff --run $(ARGS)

# Image Decoder - Finds a message hidden in an image.
image_decode:
	processing-java --sketch=image_processing/image_decoder --run $(ARGS)

# Audio Encoder - Hides message from plaintext or file in an audio file.
audio_encode:
	processing-java --sketch=audio_processing/audio_encoder --run $(ARGS)

# Audio Decoder - Finds a message hidden in an audio file.
audio_decode:
	processing-java --sketch=audio_processing/audio_decoder --run $(ARGS)

# Image Diff - Removes default generated files.
clean:
	rm -f encoded.png encoded.wav