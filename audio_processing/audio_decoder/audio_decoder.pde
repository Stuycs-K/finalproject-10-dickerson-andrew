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
    println("Usage: -iA <inputAudio> -o <outputImage> -d <displayImage?>");
    exit();
  }

  if(!parseArgs()){
    println("Parsing argument error;");
    return;
  }

  try {
    byte[] wavData = loadWav(inputAudio);
    int[] extractedBits = extractBitsFromWav(wavData, imageWidth * imageHeight * 6);
    decodedImage = bitArrayToImage(extractedBits, imageWidth, imageHeight);
    decodedImage.save(outputImage);
  } catch (Exception e) {
    e.printStackTrace();
  }

  exit();
}

boolean parseArgs() {
  //println("debug: PARSING ARGS");
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
  //println("debug: LOADING WAV");
  File file = new File(sketchPath(filename));
  byte[] data = new byte[(int) file.length()];
  FileInputStream f = new FileInputStream(file);
  f.read(data);
  f.close();
  return data;
}

int[] extractBitsFromWav(byte[] wavData, int bitCount) {
  //println("debug: EXTRACTING BITS");
  int headerSize = 44;
  int[] bits = new int[bitCount];
  int bitIndex = 0;

  for (int i = headerSize; i < wavData.length && bitIndex < bitCount; i++) {
    bits[bitIndex++] = wavData[i] & 0x01;
  }

  return bits;
}

PImage bitArrayToImage(int[] bits, int width, int height) {
  //println("debug: WRITING BITS TO IMG");
  PImage img = createImage(width, height, RGB);
  img.loadPixels();

  for (int i = 0; i < img.pixels.length; i++) {
    int bitIdx = i * 6;
    if (bitIdx + 5 >= bits.length) break;
    
    int r = (bits[bitIdx] | (bits[bitIdx + 1] << 1));
    int g = (bits[bitIdx + 2] | (bits[bitIdx + 3] << 1));
    int b = (bits[bitIdx + 4] | (bits[bitIdx + 5] << 1));

    img.pixels[i] = color(r << 6, g << 6, b << 6);
  }

  img.updatePixels();
    
  if (displayImage.toLowerCase().equals("true")) {
    image(img, width, height);
  }
  
  return img;
}
