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

  int messageLength = bits.size();
  int width = img.width;
  int height = img.height;
  
  int[] bitArray = new int[messageLength + 24 + 16 + 16];
  
  for (int i = 0; i < 24; i++) {
    bitArray[i] = (messageLength >> (23 - i)) & 1;
  }
  for (int i = 0; i < 16; i++) {
    bitArray[24 + i] = (width >> (15 - i)) & 1;
  }
  for (int i = 0; i < 16; i++) {
    bitArray[24 + 16 + i] = (height >> (15 - i)) & 1;
  }
  for (int i = 0; i < bits.size(); i++) {
    bitArray[24 + 16 + 16 + i] = bits.get(i);
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
  printHeaderInfo(data);
  
  int fileSize = data.length;
  int chunkSize = fileSize - 8;
  data[4] = (byte)(chunkSize & 0xFF);
  data[5] = (byte)((chunkSize >> 8) & 0xFF);
  data[6] = (byte)((chunkSize >> 16) & 0xFF);
  data[7] = (byte)((chunkSize >> 24) & 0xFF);
  
  int subchunk2Size = fileSize - 44;
  data[40] = (byte)(subchunk2Size & 0xFF);
  data[41] = (byte)((subchunk2Size >> 8) & 0xFF);
  data[42] = (byte)((subchunk2Size >> 16) & 0xFF);
  data[43] = (byte)((subchunk2Size >> 24) & 0xFF);
  
  FileOutputStream fos = new FileOutputStream(sketchPath(filename));
  fos.write(data);
  fos.close();
  
  if (displayImage.toLowerCase().equals("true")) {
    //OPEN THE WAVE IN AUDACITY
  }
  printHeaderInfo(data);
}

boolean checkCapacity(byte[] wavData, int bitCount) {
  int headerSize = 44;
  int maxBits = (wavData.length - headerSize) / 2;
  return bitCount <= maxBits;
}

void printHeaderInfo(byte[] data) {
  int chunkSize = (data[7] & 0xFF) << 24 | (data[6] & 0xFF) << 16 | (data[5] & 0xFF) << 8 | (data[4] & 0xFF);
  int subchunk2Size = (data[43] & 0xFF) << 24 | (data[42] & 0xFF) << 16 | (data[41] & 0xFF) << 8 | (data[40] & 0xFF);
  println("(DEBUG) ChunkSize: " + chunkSize);
  println("(DEBUG) Subchunk2Size: " + subchunk2Size);
}
