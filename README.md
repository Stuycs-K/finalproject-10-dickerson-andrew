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

Flags for make audio_encode:
- -iP : input (Picture) file that will be used as the base image to house the encoded message
- -iA : input (Audio) file that will be used as the base audio to house the encoded message
- -o : output file for which the final encrypted audio file will be stored as
- -m : mode of encryption by which the message is being encoded (GREEDY / SELECTIVE / FILE)
- -p : message that is being encoded

Flags for make audio_decode:
- -i : input (Picture) file that will be decoded
- -o : (optional) output file for which the decrypted message will be stored as
- -m : mode of encryption by which the message is being decoded (GREEDY / SELECTIVE / FILE)
- -b : (optional) number of bits the message is known to take up (helps with SELECTIVE and FILE decoding modes)

Suggested Example Commands:
> make audio_encode ARGS="-i input.png -o encoded.png -m GREEDY -d TRUE -p 'Oh look, a hidden message\!'"
> make audio_encode ARGS="-i input.png -o encoded.png -m SELECTIVE -d TRUE -p 'Oh look, a hidden message\!'"

> make audio_decode ARGS="-i encoded.mp3 -m GREEDY -d TRUE"
> make audio_decode ARGS="-i encoded.mp3 -m SELECTIVE -d TRUE"

### Resources/ References:

list here(CHANGE THIS!!!!!)
