import processing.sound.*;
import java.io.*;

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
    println("Usage: -iA <inputAudio> -o <outputImage> -d <displayImage?> -w <imageWidth> -h <imageHeight>");
    exit();
  }

  if(!parseArgs()){
    println("Parsing argument error.");
    return;
  }

  try {
    byte[] wavData = loadWav(inputAudio);
    
    int[] headerBits = extractBitsFromWav(wavData, 24);
    int messageLength = 0;
    for (int i = 0; i < 24; i++) {
      messageLength = (messageLength << 1) | headerBits[i];
    }

    int bitCapacity = (wavData.length - 44);
    println("(DEBUG) Total bits in audio: " + bitCapacity);
    
    int[] extractedBits = extractBitsFromWav(wavData, 24 + messageLength);
    int[] imageBits = subset(extractedBits, 24);

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
    if (args[i].equals("-i")) {
      try { 
        inputAudio = args[++i]; 
      } catch(Exception e) {
        println("-i requires .wav file path as next argument.");
        return false;
      }
    }
    if (args[i].equals("-o")) {
      try { 
      outputImage = args[++i];
      } catch(Exception e) {
        println("-o requires image file path as next argument.");
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
    if (args[i].equals("-w")) {
      try { 
      imageWidth = int(args[++i]);
      } catch(Exception e) {
        println("-w requires integer as next argument");
        return false;
      }
    }
    if (args[i].equals("-h")) {
      try { 
      imageHeight = int(args[++i]);
      } catch(Exception e) {
        println("-h requires integer as next argument");
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
  int maxBits = (wavData.length - headerSize) / 2; 
  if (bits.length > maxBits) {
    println("Not enough space in audio file to embed image, please use a larger audio file.");
    exit();
  }
  
  int bitIndex = 0;
  int step = 2;

  for (int i = headerSize + 1; i < wavData.length && bitIndex < bitCount; i += step) {
    bits[bitIndex++] = wavData[i] & 0x01;
  }
  println("(DEBUG) Bits in image = " + (bits.length - 24) + " should be " + imageWidth * imageHeight * 24);
  println("(DEBUG) Max bits storable in wav file = " + maxBits);
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
