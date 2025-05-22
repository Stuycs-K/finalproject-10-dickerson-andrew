[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/am3xLbu5)
# Image to Audio Encryption
 
### GROUP NAME HERE (CHANGE THIS!!!!!)

Andrew Dickerson
       
### Project Description:

This project is an extension of the `image_processing` lab. The processing program, `audio_encode` takes message as an input, encodes that the message into an image using the modified `image_encoder.pde`, then converts this image to a wav file, and overlays it with an existing mp3 file to successfully hide the message.

The decoder works essentially by doing everything in reverse. It takes the altered portions of the mp3 file, and recreates the encoded image. It then translates the binary-encoded message from this image into readable ASCII characters that it will return.
  
### Instructions:

How does the user install/compile/run the program. (CHANGE THIS!!!!!)
How does the user interact with this program? (CHANGE THIS!!!!!)

Full Encoder - Hides message from plaintext or file in an image and then hides that image in an audio file.
make encode:
- -iP : input image path (default = none, a blank, black image will be generated for use instead)
- -oP : output image path (default = "encoded.png")
- -iM : intermediate image path; input image path for audio encoding (default = path specified in -oP)
- -iA : input image path (default = "examples/oxp.wav")
- -oA : output audio path (default = "examples/encoded.wav")
- -p : plaintext message or text file name (default = "examples/secret.txt")
- -m : mode of encryption ("GREEDY", "SELECTIVE", or "FILE", default = "GREEDY")
- -d : display image after encoding ("true"/"false", default = "false")

Full Decoder - Finds an image hidden in an audio file, and then the message hidden in that image.
make decode:
- -i : input audio path (default = "obv.wav")
- -o : output audio path (default = "encoded.wav")
- -m : mode of encryption ("GREEDY", "SELECTIVE", or "FILE", default = "GREEDY")
- -b : (optional) number of bits the message is known to take up (helps with SELECTIVE and FILE decoding modes)
- -d : display image after encoding ("true"/"false", default = "false")

Image Encoder - Hides message from plaintext or file in an image.
make image_encode:
- -i : input image path (default = none, a blank, black image will be generated for use instead)
- -o : output image path (default = "encoded.png")
- -p : plaintext message or text file name (required; default = "secret.txt")
- -m : mode of encryption ("GREEDY", "SELECTIVE", or "FILE", default = "GREEDY")
- -d : display image after encoding ("true"/"false", default = "false")

Image Decoder - Finds a message hidden in an image.
make image_decode:
- -i : input image path (default = none, a blank, black image will be generated for use instead)
- -o : output image path (default = "encoded.png")
- -p : plaintext message or text file name (required; default = "secret.txt")
- -m : mode of encryption ("GREEDY", "SELECTIVE", or "FILE", default = "GREEDY")
- -d : display image after encoding ("true"/"false", default = "false")
- -b : (optional) number of bits the message is known to take up (helps with SELECTIVE and FILE decoding modes)

Audio Encoder - Hides message from plaintext or file in an audio file.
make audio_encode:
- -iP : input image path (default = "encoded.png")
- -iA : input image path (default = "oxp.wav")
- -o : output audio path (default = "encoded.wav")

Audio Decoder - Finds a message hidden in an audio file.
make audio_decode:
- -i : input audio path (default = "obv.wav")
- -o : output audio path (default = "encoded.wav")

For Example Make Commands, see `examples/ex_make_commands`

### Resources/ References:

- https://www.programiz.com/java-programming/fileinputstream
- https://www.programiz.com/java-programming/fileoutputstream
- https://stackoverflow.com/questions/26554530/reading-and-writing-wav-files-in-java
