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

Note that the "Full Encoder/Decoder" represents the project as a whole, the "Audio Encoder/Decoder" is comprised of parts new for this project, and the "Image Encoder/Decoder" is based largely of its respective lab, with some changes for compatability and ease of use within the "Full Encoder/Decoder".

**Full Encoder** - Hides message from plaintext or file in an image and then hides that image in an audio file.
make encode:
- -iP : input image path (default = none, a blank, black image will be generated for use instead)
- -oP : output image path (default = "encoded.png")
- -iM : intermediate image path; input image path for audio encoding (default = path specified in -oP)
- -iA : input image path (default = "examples/oxp.wav")
- -oA : output audio path (default = "examples/encoded.wav")
- -p : plaintext message or text file name (default = "examples/secret.txt")
- -m : mode of encryption ("GREEDY", "SELECTIVE", or "FILE", default = "GREEDY")
- -d : display image after encoding ("true"/"false", default = "false")

**Full Decoder** - Finds an image hidden in an audio file, and then the message hidden in that image.
make decode:
- -i : input audio path (default = "obv.wav")
- -oP : output image path (default = "encoded.png")
- -o : output decoded path (default = "decoded.txt")
- -m : mode of encryption ("GREEDY", "SELECTIVE", or "FILE", default = "GREEDY")
- -b : (optional) number of bits the message is known to take up (helps with SELECTIVE and FILE decoding modes)
- -d : display image after encoding ("true"/"false", default = "false")
- -w : output image width (default = 100)
- -h : display image height (default = 100)

**Image Encoder** - Hides message from plaintext or file in an image.
make image_encode:
- -i : input image path (default = none, a blank, black image will be generated for use instead)
- -o : output image path (default = "encoded.png")
- -p : plaintext message or text file name (required; default = "secret.txt")
- -m : mode of encryption ("GREEDY", "SELECTIVE", or "FILE", default = "GREEDY")
- -d : display image after encoding ("true"/"false", default = "false")

**Image Decoder** - Finds a message hidden in an image.
make image_decode:
- -i : input image path (default = none, a blank, black image will be generated for use instead)
- -o : output decoded path (default = "encoded.png")
- -m : mode of encryption ("GREEDY", "SELECTIVE", or "FILE", default = "GREEDY")
- -b : (optional) number of bits the message is known to take up (helps with SELECTIVE and FILE decoding modes)

**Audio Encoder** - Hides message from plaintext or file in an audio file.
make audio_encode:
- -iP : input image path (default = "encoded.png")
- -iA : input image path (default = "oxp.wav")
- -o : output audio path (default = "encoded.wav")
- -d : display wave after encoding ("true"/"false", default = "false")

**Audio Decoder** - Finds a message hidden in an audio file.
make audio_decode:
- -i : input audio path (default = "obv.wav")
- -o : output image path (default = "encoded.png")
- -d : display image after encoding ("true"/"false", default = "false")
- -w : output image width (default = 100)
- -h : display image height (default = 100)

For Example Make Commands, see `examples/ex_make_commands`

### Resources/ References:

- https://www.programiz.com/java-programming/fileinputstream
- https://www.programiz.com/java-programming/fileoutputstream
- https://stackoverflow.com/questions/26554530/reading-and-writing-wav-files-in-java
- https://stackoverflow.com/questions/43323575/processing-saving-to-txt-file
