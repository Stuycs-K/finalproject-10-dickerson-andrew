import processing.sound.*;
import java.io.*;

String originalAudio="audio.wav";
String modifiedAudio="audio_modified.wav";
String verbose = "false";

void setup() {
  if (args == null || args.length == 0) {
    println("Invalid or missing arguments.");
    println("Usage: -o <originalAudio> -m <modifiedAudio>");
    exit();
  }

  if(!parseArgs()){
    println("Parsing argument error.");
    return;
  }

  findAudioDiff();
  exit();
}

void findAudioDiff() {
  try {
    byte[] ogData = loadWav(originalAudio);
    byte[] modData = loadWav(modifiedAudio);

    int minLength = min(ogData.length, modData.length);
    int totalDifferences = 0;

    for (int i = 0; i < minLength; i++) {
      if (ogData[i] != modData[i]) {
        int diffBits = countBitDifferences(ogData[i], modData[i]);
        if(verbose.equalsIgnoreCase("true")) {
          println("Byte index " + i + ": original = " + byteToBits(ogData[i]) +
                  ", modified = " + byteToBits(modData[i]) +
                  ", bit differences = " + diffBits);
        }
        totalDifferences += diffBits;
      }
    }

    if (ogData.length != modData.length) {
      println("Files are different lengths. It is recommended to use files of the same binary length for optimal results.");
      totalDifferences += abs(ogData.length - modData.length) * 8;
    }

    println("Total bit differences: " + totalDifferences);

  } catch (Exception e) {
    e.printStackTrace();
  }
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

int countBitDifferences(byte a, byte b) {
  return Integer.bitCount((a ^ b) & 0xFF);
}

String byteToBits(byte b) {
  return String.format("%8s", Integer.toBinaryString(b & 0xFF)).replace(' ', '0');
}

boolean parseArgs(){
  if (args != null) {
    for (int i = 0; i < args.length; i++){

      if(args[i].equals("-o")){
        if(args[i+1]!=null){
          originalAudio=args[i+1];
        }else{
          println("-o requires wav filename as next argument");
          return false;
        }
      }

      if(args[i].equals("-m")){
        if(args[i+1]!=null){
          modifiedAudio=args[i+1];
        }else{
          println("-m requires wav filename as next argument");
          return false;
        }
      }
      
      if(args[i].equals("-v")){
        if(args[i+1]!=null){
          verbose=args[i+1];
        }else{
          println("-v requires boolean (True/False) as next argument");
          return false;
        }
      }
    }
  }
  return true;
}
