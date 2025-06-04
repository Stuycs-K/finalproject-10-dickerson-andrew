[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/am3xLbu5)
# Image to Audio Encryption
 
### The *Other* Audio Encryption Project

Andrew Dickerson

### Project Description:

This project is an extension of the `image_processing` lab. The processing program, `audio_encode` takes message as an input, encodes that the message into an image using the modified `image_encoder.pde`, then converts this image to a wav file, and overlays it with an existing wav file to successfully hide the message.

The decoder works essentially by doing everything in reverse. It takes the altered portions of the wav file, and recreates the encoded image. It then translates the binary-encoded message from this image into readable ASCII characters that it will return.

### Instructions:

**How does the user install/compile/run the program?**

The user runs the program by executing a make command for the respective program they are attempting to run.

Example make commands have been provided in `examples/ex_make_commands.txt`.

These example commands use example files that are also located in the `examples` directory.

To use any other files outside this directory as arguments for the make command, the path of this file must be specified either explicitly, or relative to the location of the `.pde` file of the sketch (hence the `../../examples/example.file` in the make command examples).

**How does the user interact with this program?**

The user may interact with the program by altering the flags within the make command.

For instance, the user can determine whether or not the output of the program should be displayed to them after the program runs with the `-d` flag.

The user may also determine the mode of encoding for the image using the `-m` flag.

For more information on the flags and usage of the program, a comprehensive guide to the purpose, name, and flags usage for each program has been provided below.

Note that the "Full Encoder/Decoder" represents the project as a whole, "Audio Encoder/Decoder" is comprised of parts new for this project, and the "Image Encoder/Decoder" is based largely of its respective lab, but with changes for compatability with the "Full Encoder/Decoder".

**Full Encoder** - Hides message from plaintext or file in an image and then hides that image in an audio file.
make encode:
- -iI : input image path for image_encoder (default = none, a blank, white image will be generated for use instead)
- -oI : output image path for image_encoder (default = "encoded.png")
- -p : plaintext message or text file name (required; default = "secret.txt")
- -m : mode of encryption ("GREEDY", "SELECTIVE", or "FILE", default = "GREEDY")
- -dI : display image after encoding ("true"/"false", default = "false")

- -iP : input image path for audio_encoder (default = "encoded.png")
- -iA : input image path for audio_encoder  (default = "oxp.wav")
- -oA : output audio path for audio_encoder  (default = "encoded.wav")
- -dA : display wave after encoding ("true"/"false", default = "false")

**Full Decoder** - Finds an image hidden in an audio file, and then the message hidden in that image.
make decode:
- -iA : input audio path for audio_encoder (default = "obv.wav")
- -oA : output image path for audio_encoder (default = "encoded.png")
- -dA : display image after encoding ("true"/"false", default = "false")

- -iI : input image path for image_encoder (default = none, a blank, white image will be generated for use instead)
- -oI : output decoded path for image_encoder (default = "encoded.png")
- -m : mode of encryption ("GREEDY", "SELECTIVE", or "FILE", default = "GREEDY")
- -b : (optional) number of bits the message is known to take up (helps with SELECTIVE and FILE decoding modes)

**Image Encoder** - Hides message from plaintext or file in an image.
make image_encode:
- -iI : input image path (default = none, a blank, white image will be generated for use instead)
- -oI : output image path (default = "encoded.png")
- -p : plaintext message or text file name (required; default = "secret.txt")
- -m : mode of encryption ("GREEDY", "SELECTIVE", or "FILE", default = "GREEDY")
- -dI : display image after encoding ("true"/"false", default = "false")

**Image Decoder** - Finds a message hidden in an image.
make image_decode:
- -iI : input image path (default = none, a blank, white image will be generated for use instead)
- -oI : output decoded path (default = "encoded.png")
- -m : mode of encryption ("GREEDY", "SELECTIVE", or "FILE", default = "GREEDY")
- -b : (optional) number of bits the message is known to take up (helps with SELECTIVE and FILE decoding modes)

**Image Diff** – Highlights pixel differences between two provided images.
make image_diff:
- -o : path to the original image (default = "cat.png")
- -m : path to the modified image (default = "modifiedCat.png")
Press any key to cycle through modes:
- DEFAULT: shows original image (img1)
- DIFF: highlights any differing pixels in magenta
- DIFF_R: highlights red channel differences in red
- DIFF_G: highlights green channel differences in green
- DIFF_B: highlights blue channel differences in blue

**Audio Encoder** - Hides message from plaintext or file in an audio file.
make audio_encode:
- -iP : input image path (default = "encoded.png")
- -iA : input image path (default = "oxp.wav")
- -oA : output audio path (default = "encoded.wav")
- -dA : display wave after encoding ("true"/"false", default = "false")

**Audio Decoder** - Finds a message hidden in an audio file.
make audio_decode:
- -iA : input audio path (default = "obv.wav")
- -oA : output image path (default = "encoded.png")
- -dA : display image after encoding ("true"/"false", default = "false")

**Audio Diff** – Compares two .wav files at the byte level and reports the total number of bit differences.
make audio_diff:
- -o : original WAV file path (default = "audio.wav")
- -m : modified WAV file path (default = "audio_modified.wav")
- -v : (optional) "true" enables verbose mode, which prints bit differences within each differing byte (default = "false")

**Clean** - Removes default generated output files.
- No flags, just run `make clean`.

For Example Make Commands, see `examples/ex_make_commands`

### Resources/ References:

- https://www.programiz.com/java-programming/fileinputstream
- https://www.programiz.com/java-programming/fileoutputstream
- https://stackoverflow.com/questions/26554530/reading-and-writing-wav-files-in-java
- https://stackoverflow.com/questions/43323575/processing-saving-to-txt-file
- https://docs.fileformat.com/audio/wav/
- https://blog.fileformat.com/audio/understanding-the-wav-file-header-structure-format-and-how-to-repair/
- http://soundfile.sapp.org/doc/WaveFormat/
- https://yout.com/
