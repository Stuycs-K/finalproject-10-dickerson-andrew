import java.io.*;

PImage encodedImage;
String inputImage = "encoded.png";
String inputAudio = "base.wav";
String outputAudio = "output.wav";
int[] messageBits;

void setup() {
  size(200, 200);
 
  if (args == null || args.length == 0) {
    println("Invalid or missing arguments.");
    println("Usage: -iP <inputImage> -iA <inputAudio> -o <outputAudio>");
    exit();
  }

  parseArgs();

  encodedImage = loadImage(inputImage);
  messageBits = imageToBitArray(encodedImage);

  exit();
}

void parseArgs() {
  for (int i = 0; i < args.length; i++) {
    if (args[i].equals("-iP")) inputImage = args[++i];
    if (args[i].equals("-iA")) inputAudio = args[++i];
    if (args[i].equals("-o")) outputAudio = args[++i];
  }
}
