[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/am3xLbu5)
# PROJECT NAME HERE (CHANGE THIS!!!!!)
Image to Audio Encryption
 
### GROUP NAME HERE (CHANGE THIS!!!!!)

Andrew Dickerson
       
### Project Description:

This project is an extension of the `image_processing` lab. The processing program, `audio_encode` takes message as an input, encodes that the message into an image using the modified `image_encoder.pde`, then converts this image to a wav file, and overlays it with an existing mp3 file to successfully hide the message.

The decoder works essentially by doing everything in reverse. It takes the altered portions of the mp3 file, and recreates the encoded image. It then translates the binary-encoded message from this image into readable ASCII characters that it will return.
  
### Instructions:

How does the user install/compile/run the program. (CHANGE THIS!!!!!)
How does the user interact with this program? (CHANGE THIS!!!!!)

Image Encoder - Hides message from plaintext or file in an image.
make flags:
- -i : input image path (default = none, a blank, black iamge will be generated for use instead)
- -o : output image path (default = "encoded.png")
- -p : plaintext message or text file name (required; default = "secret.txt")
- -m : mode of encryption ("GREEDY", "SELECTIVE", or "FILE", default = "GREEDY")
- -d : display image after encoding ("true"/"false", default = "false")

Image Decoder - Finds a message hidden in an image.
make flags:
- -i : input image path (default = none, a blank, black iamge will be generated for use instead)
- -o : output image path (default = "encoded.png")
- -p : plaintext message or text file name (required; default = "secret.txt")
- -m : mode of encryption ("GREEDY", "SELECTIVE", or "FILE", default = "GREEDY")
- -d : display image after encoding ("true"/"false", default = "false")
- -b : (optional) number of bits the message is known to take up (helps with SELECTIVE and FILE decoding modes)

Audio Encoder - Hides message from plaintext or file in an audio file.
make flags:
- -iP : input image path (default = none, a blank, black iamge will be generated for use instead)
- -iA : input image path (default = "oxp.wav")
- -o : output audio path (default = "encoded.wav")
- -p : plaintext message or text file name (default = "This is a hidden message.")
- -m : mode of encryption ("GREEDY", "SELECTIVE", or "FILE", default = "GREEDY")

Audio Decoder - Finds a message hidden in an audio file.
make flags:
- -i : input audio path (default = "obv.wav")
- -o : output audio path (default = "encoded.wav")
- -p : plaintext message or text file name (default = "This is a hidden message.")
- -m : mode of encryption ("GREEDY", "SELECTIVE", or "FILE", default = "GREEDY")
- -b : (optional) number of bits the message is known to take up (helps with SELECTIVE and FILE decoding modes)

For Example Make Commands, see `examples/ex_make_commands`

### Resources/ References:

list here(CHANGE THIS!!!!!)
