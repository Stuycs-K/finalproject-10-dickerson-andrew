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

  if(!parseArgs()){
    println("Parsing argument error.");
    return;
  }

  encodedImage = loadImage(inputImage);
  messageBits = imageToBitArray(encodedImage);

  try {
    byte[] wavData = loadWav(inputAudio);
    
    if (!checkCapacity(wavData, messageBits.length)) {
      println("ERROR: The image is too large to embed in the provided audio file.");
      println("Bits required: " + messageBits.length);
      println("Bits available: " + ((wavData.length - 44) / 2));
      exit();
    }
    
    byte[] encodedWav = embedBitsInWav(wavData, messageBits);
    saveWav(encodedWav, outputAudio);
  } catch (Exception e) {
    e.printStackTrace();
  }

  exit();
}

boolean parseArgs() {
  //println("debug: PARSING ARGS");
  for (int i = 0; i < args.length; i++) {
    if (args[i].equals("-iP")) {
      try { 
        inputImage = args[++i]; 
      } catch(Exception e) {
        println("-iP requires image file path as next argument.");
        return false;
      }
    }
    if (args[i].equals("-iA")) {
      try { 
      inputAudio = args[++i];
      } catch(Exception e) {
        println("-iA requires .wav file path as next argument.");
        return false;
      }
    }
    if (args[i].equals("-o")) {
      try { 
      outputAudio = args[++i];
      } catch(Exception e) {
        println("-o requires .wav file path as next argument.");
        return false;
      }
    }
    if (args[i].equals("-d")) {
      try { 
      displayImage = args[++i];
      } catch(Exception e) {
        println("-d requires boolean (True/False) as next argument");
        return false;
      }
    }
    
  }
  return true;
}

int[] imageToBitArray(PImage img) {
  //println("debug: CONVERTING IMG TO BITS");
  img.loadPixels();
  ArrayList<Integer> bits = new ArrayList<Integer>();
  for (color c : img.pixels) {
    int r = (int) red(c);
    int g = (int) green(c);
    int b = (int) blue(c);
  
    for (int i = 0; i < 8; i++) {
      bits.add((r >> i) & 0x01);
    }
    for (int i = 0; i < 8; i++) {
      bits.add((g >> i) & 0x01);
    }
    for (int i = 0; i < 8; i++) {
      bits.add((b >> i) & 0x01);
    }
  }

  int[] bitArray = new int[bits.size() + 24];
  int messageLength = bits.size();
  for (int i = 0; i < 24; i++) {
    bitArray[i] = (messageLength >> (23 - i)) & 1;
  }

  for (int i = 0; i < bits.size(); i++) {
    bitArray[i+24] = bits.get(i);
  }
  
  return bitArray;
}

byte[] loadWav(String filename) throws IOException {
  //println("debug: LOADING WAV");
  File file = new File(sketchPath(filename));
  byte[] data = new byte[(int) file.length()];
  FileInputStream f = new FileInputStream(file);
  f.read(data);
  f.close();
  return data;
}

byte[] embedBitsInWav(byte[] wavData, int[] bits) {
  //println("debug: EMBEDDING BITS");
  int headerSize = 44;
  int bitIndex = 0;
  int step = 2;

  for (int i = headerSize + 1; i < wavData.length && bitIndex < bits.length; i += step) {
    wavData[i] = (byte) ((wavData[i] & 0xFE) | bits[bitIndex]);
    bitIndex++;
  }

  return wavData;
}

void saveWav(byte[] data, String filename) throws IOException {
  //println("debug: SAVING WAV");
  FileOutputStream fos = new FileOutputStream(sketchPath(filename));
  fos.write(data);
  fos.close();
  
  if (displayImage.toLowerCase().equals("true")) {
    //OPEN THE WAVE IN AUDACITY
  }
 
}

boolean checkCapacity(byte[] wavData, int bitCount) {
  int headerSize = 44;
  int maxBits = (wavData.length - headerSize) / 2;
  return bitCount <= maxBits;
}
