import java.io.*;
import processing.sound.*;

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

int[] imageToBitArray(PImage img) {
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
  File file = new File(sketchPath(filename));
  byte[] data = new byte[(int) file.length()];
  FileInputStream fis = new FileInputStream(file);
  fis.read(data);
  fis.close();
  return data;
}

byte[] embedBitsInWav(byte[] wavData, int[] bits) {
  int headerSize = 44;
  int bitIndex = 0;

  for (int i = headerSize; i < wavData.length && bitIndex < bits.length; i++) {
    wavData[i] = (byte) ((wavData[i] & 0xFE) | bits[bitIndex]);
    bitIndex++;
  }

  println("Embedded " + bitIndex + " bits into audio.");
  return wavData;
}

void saveWav(byte[] data, String filename) throws IOException {
  FileOutputStream fos = new FileOutputStream(sketchPath(filename));
  fos.write(data);
  fos.close();
}
