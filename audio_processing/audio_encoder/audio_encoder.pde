import java.io.*;
import processing.sound.*;

PImage encodedImage;
String inputImage = "encoded.png";
String inputAudio = "base.wav";
String outputAudio = "output.wav";
String displayImage = "false";
int[] messageBits;

void setup() {
  size(200, 200);
 
  if (args == null || args.length == 0) {
    println("Invalid or missing arguments.");
    println("Usage: -iP <inputImage> -iA <inputAudio> -o <outputAudio>  -d <displayImage?>");
    exit();
  }

  parseArgs();

  encodedImage = loadImage(inputImage);
  messageBits = imageToBitArray(encodedImage);

  try {
    byte[] wavData = loadWav(inputAudio);
    byte[] encodedWav = embedBitsInWav(wavData, messageBits);
    saveWav(encodedWav, outputAudio);
  } catch (Exception e) {
    e.printStackTrace();
  }

  exit();
}

void parseArgs() {
  //println("PARSING ARGS");
  for (int i = 0; i < args.length; i++) {
    if (args[i].equals("-iP")) inputImage = args[++i];
    if (args[i].equals("-iA")) inputAudio = args[++i];
    if (args[i].equals("-o")) outputAudio = args[++i];
    if (args[i].equals("-d")) displayImage = args[++i];
  }
}

int[] imageToBitArray(PImage img) {
  //println("CONVERTING IMG TO BITS");
  img.loadPixels();
  ArrayList<Integer> bits = new ArrayList<Integer>();
  for (color c : img.pixels) {
  int r = (int) red(c);
  int g = (int) green(c);
  int b = (int) blue(c);

  bits.add(r & 0x01);
  bits.add((r >> 1) & 0x01);
  bits.add(g & 0x01);
  bits.add((g >> 1) & 0x01);
  bits.add(b & 0x01);
  bits.add((b >> 1) & 0x01);
}

int[] result = new int[bits.size()];
  for (int i = 0; i < bits.size(); i++) result[i] = bits.get(i);
  return result;
}

byte[] loadWav(String filename) throws IOException {
  //println("LOADING WAV");
  File file = new File(sketchPath(filename));
  byte[] data = new byte[(int) file.length()];
  FileInputStream f = new FileInputStream(file);
  f.read(data);
  f.close();
  return data;
}

byte[] embedBitsInWav(byte[] wavData, int[] bits) {
  //println("EMBEDDING BITS");
  int headerSize = 44;
  int bitIndex = 0;

  for (int i = headerSize; i < wavData.length && bitIndex < bits.length; i++) {
    wavData[i] = (byte) ((wavData[i] & 0xFE) | bits[bitIndex]);
    bitIndex++;
  }

  return wavData;
}

void saveWav(byte[] data, String filename) throws IOException {
  //println("SAVING WAV");
  FileOutputStream fos = new FileOutputStream(sketchPath(filename));
  fos.write(data);
  fos.close();
  
  if (displayImage.toLowerCase().equals("true")) {
    //OPEN THE WAVE IN AUDACITY
  }
 
}
