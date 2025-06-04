# Presentation Outline
1. Contents of `README.md`:
	a. Project Description / Overview
	b. Instructions
	c. Flags for each sketch
	d. References

2. `image_encoder`
	a. Review of Functionality of `image_encoder`.
		Takes a message in the form of plaintext or a TXT file path and encodes an image with a hidden message using least significant bit (LSB) encoding.
	
	b. Changes necessary for compatability with `audio_encoder`.
		i. checkImageCapacity():
			- Prevents encoding if the message exceeds the available embedding space.

		ii. Improved Argument Parsing and Validation:
			- More rigorous error checking was added (ex:, checking for invalid file paths, missing arguments, and invalid modes).
			Prevents crashes or undefined behavior during runtime and ensures all necessary inputs are properly provided.

		iii. Improvement of Termination Sequence Handling for All Modes:
			- Termination handling (writing {3,3,3,3} in GREEDY mode, altering red channel LSBs in SELECTIVE/FILE) ensures audio_decoder can recognize and stop reading the embedded image's message to prevent issues with decoding.

		iv. Refined Message Encoding with Bit Packing:
			- The messageToArray() method structures the message into 2-bit segments, which aligns with how audio_encoder and audio_decoder read and write bits.

		v. Consistent Pixel Qualification Rules:
			- The logic for qualifying pixels in SELECTIVE/FILE mode ensures only those with red and green channels ending in 00 are used — the same constraint applied when decoding audio, maintaining parity across encoding and decoding.

		vi. Display and Exit Behavior for Non-GUI Mode:
			- Conditional exit() based on DISPLAYMODE supports automated encoding workflows, such as those used in audio pipelines (image -> audio), without requiring GUI display.	
	
	c. Running test cases from `example_make_commands`.

3. `audio_encoder`
	a. Introduction to functionality of `image_encoder`.
		This sketch takes a PNG image that is already encoded with a hidden message and embeds the pixels of this image into the LSBs of a WAV audio file.
	
	b. General process by which `audio_encoder` embeds the image data within a wav file. 
		i. Passing Command-Line Arguments into Global Variablese(parseArgs)
			- See flag info and usage in `README.md`.

		ii. Image Loading and Bit Conversion (imageToBitArray)
			- The input image is loaded using loadImage.
			- Each pixel’s RGB values are extracted and converted into 24 bits, with 8 bits for each color.
			- A 56-bit header is prepended to the message:
				24 bits: Total number of data bits (image content)
				16 bits: Image width
				16 bits: Image height
			
			- The resulting array (messageBits) represents the full message and prepended header as bits to be encoded.

		iii. WAV File Loading (loadWav)
			- The WAV audio file is read as a byte array and the original 44-byte header is preserved.

		iv. Capacity Check (checkCapacity)
			- Verifies that the audio file has enough bytes (post-header) to hide all the image bits.
			- Uses a step = 2, (encodes one bit into every other byte to reduce distortion).

		v. Bit Embedding (embedBitsInWav)
			- Starting after the 44-byte header, it replaces the least significant bit of every second byte with the bits from the image.
			- This modifies the audio very slightly and imperceptibly.

		vi. WAV Saving (saveWav)
			- Updates key header values (ChunkSize, Subchunk2Size) to reflect the possibly altered file size.
			- Writes the modified byte array to a new .wav file.

		vii. Final Result
			- The output WAV file (output.wav) is a valid audio file that sounds nearly identical to the original.
			- `output.wav` contains an embedded image that can be decoded later using a compatible audio_decoder.
	
	c. Running test cases from `example_make_commands`.


4. `audio_diff`
	a. Review of functionality of `audio_diff`.
		This sketch takes two WAV audio files and prints the number of bit differences between them.
	
	b. General process by which `audio_diff` finds the bit differences between two audio files. 
		i. Passing Command-Line Arguments into Global Variables (parseArgs)
			- See flag info and usage in `README.md`.

		ii. WAV File Loading (loadWav)
			- Both the original and modified WAV files are loaded into separate byte arrays.
			- The full contents of each file are read, including headers and data sections.

		iii. Byte-by-Byte Comparison (findAudioDiff)
			- The two audio files are compared byte-by-byte up to the length of the shorter file.
			- For every differing byte, the number of differing bits is calculated using XOR and Integer.bitCount.

		iv. Verbose Output (Conditional Logging)
			- If -v is true, every differing byte is printed along with additional information:
				Byte index
				Original byte (in binary)
				Modified byte (in binary)
				Number of differing bits at that byte

		v. Handling of Unequal File Lengths
			- If the files are of unequal length, a warning is printed.
			- The difference in length (in bytes) is converted to a bit count (×8) and added to the total difference count.

		vi. Final Result
			- The program prints the total number of bit differences between the two WAV files.
			- This can be used to evaluate the extent of changes caused by encoding (ex: via LSB steganography).

	c. Running test cases from `example_make_commands`.
	

5. `audio_decoder`
	a. Introduction to functionality of `image_encoder`.
		This sketch takes a PNG image that is already encoded with a hidden message and embeds the pixels of this image into the least significant bits of a WAV audio file.
	
	b. General process by which `audio_decoder` retrieves the image data from the wav file. 
		i. Passing Command-Line Arguments into Global Variables (parseArgs)
			- See flag info and usage in `README.md`.

		ii. WAV File Loading (loadWav)
			- The encoded WAV file is loaded as a byte array from disk.
			- The first 44 bytes (standard WAV header) are preserved and skipped for decoding purposes.

		iii. Bitstream Extraction (extractBitsFromWav)
			- Starting from byte 44, every second byte is read (w/ step = 2).
			- The least significant bit (LSB) of each of these bytes is extracted into a bitCount-sized array.
			- These bits represent the hidden image plus metadata.

		iv. Header Decoding
			- The first 56 bits are interpreted as follows:
				24 bits -> messageLength: total number of bits in the hidden image
				16 bits -> imageWidth in pixels
				16 bits -> imageHeight in pixels

		v. Image Bit Extraction
			- The remaining bits (after the 56-bit header) are extracted as a new array:
				Total size = imageWidth × imageHeight × 24 (8 bits per color in RGB)

		vi. Image Reconstruction (bitArrayToImage)
			- Each pixel is rebuilt from 24 consecutive bits.
			- The full PImage is created using createImage, populated, and saved to disk.

		vii. Optional Image Display
			- If the -dA flag is true, the image is displayed in the Processing window using image().

		viii. Final Result
			- The extracted image is saved to the given output path.
			- The decoded image should be identical to the original image embedded using `audio_encoder`.
	
	c. Running test cases from `example_make_commands`.


6. `image_diff`
	a. Review of functionality of `image_diff`.
		Highlights pixel differences between two provided images.

	b. Running test cases from `example_make_commands`.


7. `image_decoder`
	a. Review of functionality of `image_decoder`.
		Extracts and decodes a hidden message or file from an image's pixel data using a selected encoding mode (GREEDY, SELECTIVE, or FILE).
	
	b. Changes made for compatability with `audio_decoder`.
		i. Added Terminator Byte for GREEDY Mode
			- A termination condition was added for GREEDY mode: if a byte with the value 255 is encountered during decoding, it is treated as the end of the message and decoding halts. This ensures GREEDY-mode messages do not contain lingering null or garbage values when interpreted by audio_decoder.

		ii. Output Handling Enhancement
			- A hasOutputFile boolean flag was introduced to determine whether the decoded message should be printed to the console or saved to an output file. This allows compatibility with audio_decoder, which may require writing to disk instead of standard output.

		iii. Extended Output Support for FILE Mode
			- Support for saving both text and binary output depending on mode:
			- In FILE mode, decoded bytes are saved using saveBytes()
			- In GREEDY/SELECTIVE modes, decoded strings are saved using saveStrings().

		iv. Custom Argument Parsing for Audio Compatibility
			- The argument flags were updated from -i and -o to -iI and -oI respectively to distinguish `image_decoder` inputs from `audio_decoder` inputs in the full decoder make commands.

		v.  Warning Message for File Extensions
			- A warning message was added when saving binary data to a .txt file in FILE mode, alerting the user that the output might not be human-readable.

	c. Running test cases from `example_make_commands`.


8. Full encoder
	a. Review of functionality of full encoder.
		Hides message from plaintext or file in an image and then hides that image in an audio file.

	b. Running test cases from `example_make_commands`.


7. Full decoder
	a. Review of functionality of full decoder.
		Finds an image hidden in an audio file, and then the message hidden in that image.
	
	b. Running test cases from `example_make_commands`.

