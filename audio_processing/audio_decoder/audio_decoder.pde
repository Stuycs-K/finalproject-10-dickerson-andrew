import processing.sound.*;
import java.io.*;

PImage decodedImage;
String outputImage = "decoded.png";
String inputAudio = "encoded.wav";
String displayImage = "false";
int imageWidth = 0;
int imageHeight = 0;

void setup() {
  size(200, 200);

  if (args == null || args.length == 0) {
    println("Invalid or missing arguments.");
    println("Usage: -iA <inputAudio> -oA <outputImage> -dA <displayImage?>");
    exit();
  }

  if(!parseArgs()){
    println("Parsing argument error.");
    return;
  }

  try {
    byte[] wavData = loadWav(inputAudio); 
    int maxBits = (wavData.length - 44) / 2;
    //println("(DEBUG) Bit space in wav (w/ step = 2): " + maxBits);
    int[] fullBitStream = extractBitsFromWav(wavData, maxBits); // extract all useful bits
    
    int messageLength = 0;
    for (int i = 0; i < 24; i++) {
      messageLength = (messageLength << 1) | fullBitStream[i];
    }
    int imageWidth = 0;
    for (int i = 0; i < 16; i++) {
      imageWidth = (imageWidth << 1) | fullBitStream[24 + i];
    }
    int imageHeight = 0;
    for (int i = 0; i < 16; i++) {
      imageHeight = (imageHeight << 1) | fullBitStream[40 + i];
    }
    
    //print("(DEBUG) Header bits: ");
    //for (int i = 0; i < 56; i++) print(fullBitStream[i]);
    //println();
    
    //println("(DEBUG) Decoded image width = " + imageWidth);
    //println("(DEBUG) Decoded image height = " + imageHeight);
    //println("(DEBUG) Decoded messageLength = " + messageLength);
    
    int[] imageBits = subset(fullBitStream, 56, imageWidth * imageHeight * 24);

    decodedImage = bitArrayToImage(imageBits, imageWidth, imageHeight);
    decodedImage.save(outputImage);
  } catch (Exception e) {
    e.printStackTrace();
  }

  exit();
}

boolean parseArgs() {
  //println("(DEBUG) PARSING ARGS");
  for (int i = 0; i < args.length; i++) {
    if (args[i].equals("-iA")) {
      try { 
        inputAudio = args[++i]; 
      } catch(Exception e) {
        println("-iA requires .wav file path as next argument.");
        return false;
      }
    }
    if (args[i].equals("-oA")) {
      try { 
      outputImage = args[++i];
      } catch(Exception e) {
        println("-oA requires image file path as next argument.");
        return false;
      }
    }
    if (args[i].equals("-dA")) {
      try { 
      displayImage = args[++i];
      } catch(Exception e) {
        println("-dA requires boolean (True/False) as next argument");
        return false;
      }
    }
  }
  return true;
}

byte[] loadWav(String filename) throws IOException {
  //println("(DEBUG) LOADING WAV");
  File file = new File(sketchPath(filename));
  byte[] data = new byte[(int) file.length()];
  FileInputStream f = new FileInputStream(file);
  f.read(data);
  f.close();
  return data;
}

int[] extractBitsFromWav(byte[] wavData, int bitCount) {
  //println("(DEBUG) EXTRACTING BITS");
  int headerSize = 44;
  int[] bits = new int[bitCount];
  int bitIndex = 0;
  int step = 2;

  for (int i = headerSize; i < wavData.length && bitIndex < bitCount; i += step) {
    bits[bitIndex++] = wavData[i] & 0x01;
  }
  //println("(DEBUG) Bits extracted from wav = " + (bits.length - 56) + " should be " + imageWidth * imageHeight * 24);
  return bits;
}

PImage bitArrayToImage(int[] bits, int width, int height) {
  //println("(DEBUG) WRITING BITS TO IMG");
  PImage img = createImage(width, height, RGB);
  img.loadPixels();

  for (int i = 0; i < img.pixels.length; i++) {
    int bitIdx = i * 24;
    if (bitIdx + 23 >= bits.length) {
      break;
    }
    int r = 0, g = 0, b = 0;
    for (int j = 0; j < 8; j++) {
      r |= (bits[bitIdx + j] << j);
      g |= (bits[bitIdx + 8 + j] << j);
      b |= (bits[bitIdx + 16 + j] << j);
    }

    img.pixels[i] = color(r, g, b);
  }

  img.updatePixels();
    
  if (displayImage.toLowerCase().equals("true")) {
    image(img, width, height);
  }
  
  return img;
}
