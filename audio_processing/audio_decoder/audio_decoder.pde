import java.io.*;
import processing.sound.*;

PImage decodedImage;
String outputImage = "decoded.png";
String inputAudio = "encoded.wav";
String displayImage = "false";
int imageWidth = 100;
int imageHeight = 100;

void setup() {
  size(200, 200);

  if (args == null || args.length == 0) {
    println("Invalid or missing arguments.");
    println("Usage: -iA <inputAudio> -o <outputImage> -d <displayImage?>");
    exit();
  }

  parseArgs();
/*
  try {
    byte[] wavData = loadWav(inputAudio);
    byte[] encodedWav = embedBitsInWav(wavData, messageBits);
    saveWav(encodedWav, outputAudio);
  } catch (Exception e) {
    e.printStackTrace();
  }
*/
  exit();
}

void parseArgs() {
  println("PARSING ARGS");
  for (int i = 0; i < args.length; i++) {
    if (args[i].equals("-iA")) inputAudio = args[++i];
    if (args[i].equals("-o")) outputImage = args[++i];
    if (args[i].equals("-d")) displayImage = args[++i];
  }
}

byte[] loadWav(String filename) throws IOException {
  println("LOADING WAV");
  File file = new File(sketchPath(filename));
  byte[] data = new byte[(int) file.length()];
  FileInputStream f = new FileInputStream(file);
  f.read(data);
  f.close();
  return data;
}

int[] extractBitsFromWav(byte[] wavData, int bitCount) {
  println("EXTRACTING BITS");
  int headerSize = 44;
  int[] bits = new int[bitCount];
  int bitIndex = 0;

  for (int i = headerSize; i < wavData.length && bitIndex < bitCount; i++) {
    bits[bitIndex++] = wavData[i] & 0x01;
  }

  return bits;
}

PImage bitArrayToImage(int[] bits, int width, int height) {
  println("WRITING BITS TO IMG");
  PImage img = createImage(width, height, RGB);
  img.loadPixels();

  for (int i = 0; i < img.pixels.length; i++) {
    int r = (bits[i]);
    int g = (bits[i]);
    int b = (bits[i]);

    img.pixels[i] = color(r, g, b);
  }

  img.updatePixels();
    
  if (displayImage.toLowerCase().equals("true")) {
    image(img, width, height);
  }
  
  return img;
}
