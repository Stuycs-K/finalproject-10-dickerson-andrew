# Final Project Proposal

## Group Members:

Andrew Dickerson
       
# Intentions:

Create a processing program that will take a message as an input, encode the message into an all black image using previosly designed image_encoder.pde, then convert this image to a wav file, and overly it with an existing mp3 file to successfully hide the message.

The decoder will work essentially by doing everything in reverse, it will take the altered portions of the mp3 file, and translate the binary-encoded message into readable ASCII characters that it will return.
    
# Intended usage:

The user-interface will be very similiar to that of a lab: there will be a makefile for both encode and decode that will accept command line arguments for the mp3 file in which the message is encoded, and it will either take or output the decoded message depending on which function is being used.
  
# Technical Details:
   
I will be using the topics covered in class in the project by adding on to the development of a previous lab, creating a more secure method of encrypting a message by further obfuscating the a code-containing image into an audio file.

1. Modify the existing image_encoder.pde to alter the pixels of an all black image
2. Figure out if this image can then be used to hide a message in an audio file in such a way thtat it is easily retrievable later
3. A) This method of encoding and decoding is reasonable and the rest of the project should be continued
\n    B) This method is not reasonable and I shold revise part 1 to alter the image to display the message by changing pixels to white for every 1 in the binary string OR to modify the image such that the message is visible as plaintext within the image before the next step of encoding
4. Depending on the implementation in part 3, hide the message within the audio file
5. Isolate and retrieve the encoded image from the audio file
6. Decode the message from the image using image_decode.pde
  
    
# Intended pacing:

A timeline with expected completion dates of parts of the project. (CHANGE THIS!!!!!)
1. 5/19/25 - Image Encoder
2. 5/21/25 - Feasability and Program Accquiring
3. 5/22/25 - Changes to Part 1
4. 5/24/25 - Audio Encoder
5. 5/26/25 - Audio Decoder
6. 5/28/25 - Image Decoder
