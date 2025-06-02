import processing.sound.*;
import java.io.*;

String originalAudio="audio.wav";
String modifiedAudio="audio_modified.wav";

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


  exit();
}

void findAudioDiff(){
  try {
    byte[] ogData = loadWav(originalAudio);
    byte[] modData = loadWav(modifiedAudio);
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
    }
  }
  return true;
}
