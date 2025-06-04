import java.util.Arrays;
import java.io.File;  // Import the File class
import java.io.FileNotFoundException;  // Import this class to handle errors
import java.util.Scanner; // Import the Scanner class to read text files

final static int GREEDY = 0;
final static int SELECTIVE = 1;
final static int FILE = 2;
int MODE = GREEDY;
String INPUTFILENAME="input.png";
String OUTPUTFILENAME="outputfile";
Boolean hasOutputFile = false;

/*NEW*/
int BYTE_COUNT = -1;//the number of characters or bytes in the message. (used in SELECTIVE/FILE modes)
//modify your encode to print this value so you know what it is. 
//This will be the length of string, or size of file in bytes.

ArrayList<Integer> getParts(PImage img){
  ArrayList<Integer>parts = new ArrayList<Integer>();
  img.loadPixels();
  String[] messageArray = new String[img.width * img.height / 4];
  String encodedByte = "";
  
  if(MODE == GREEDY){
    //calculate parts here.
    for (int i = 0; i < messageArray.length; i++) {
      int r = (int)red(img.pixels[i]);
      String redBinaryString = String.format("%8s", Integer.toBinaryString(r)).replace(" ", "0");
      String lastPairRed = redBinaryString.substring(redBinaryString.length()-2);
      encodedByte += lastPairRed;
      
      if ((i + 1) % 4 == 0) {
        if (Integer.parseInt(encodedByte, 2) == 255) {
          encodedByte = "";
          break;
        } else{ 
          parts.add(Integer.parseInt(encodedByte, 2));
          encodedByte = "";
        }
      }
    }
    return parts;
  } else if(MODE == SELECTIVE || MODE == FILE) {
    //you should use BYTE_COUNT so you know how many parts there are.
    //calculate parts here.
    if (BYTE_COUNT == -1) {
      BYTE_COUNT = (img.width * img.height) / 4;
    }
    int bits_used = 0;
    for (int i = 0; i < img.width * img.height && bits_used/4 < BYTE_COUNT; i++) {
      int r = (int)red(img.pixels[i]);
      int g = (int)green(img.pixels[i]);
      int b = (int)blue(img.pixels[i]);
      
      String redBinaryString = String.format("%8s", Integer.toBinaryString(r)).replace(" ", "0");
      String lastPairRed = redBinaryString.substring(redBinaryString.length()-2);
      String greenBinaryString = String.format("%8s", Integer.toBinaryString(g)).replace(" ", "0");
      String lastPairGreen = greenBinaryString.substring(greenBinaryString.length()-2);
      String blueBinaryString = String.format("%8s", Integer.toBinaryString(b)).replace(" ", "0");
      String lastPairBlue = blueBinaryString.substring(blueBinaryString.length()-2);
      
      if (lastPairRed.equals("00") && lastPairGreen.equals("00")) {
        encodedByte += lastPairBlue;
        bits_used++;
      }
      
      if (encodedByte.length() == 8) {
        parts.add(Integer.parseInt(encodedByte, 2));
        encodedByte = "";
      }
    
    }
    return parts;
  }
  println("Error: no valid mode");
  return null;
}

//convert the parts arraylist into an array of bytes and return it
byte[] getBytes(ArrayList<Integer> parts) {
  byte[] ans = new byte[BYTE_COUNT];
  
  for (int i = 0; i < parts.size(); i++){
    ans[i] = (byte) (int) parts.get(i);
  }
  
  return ans;
}

//print the string that is created from an arraylist of parts
//parts should have: size() % 4 == 0
String decode(ArrayList<Integer>parts){
  String ans = "";
  
  for (int i = 0; i < parts.size(); i++) {
    ans += char(parts.get(i));
  }
  
  return ans;
}

//------------------DO NOT CHANGE THESE FUNCTIONS---------------------
void setup()
{
  if(args==null){
    println("no arguments provided");
    println("flags: -iI INPUTFILENAME -oI OUTPUTFILENAME -b NUMBER_OF_ENCODED_BYTES -m MODE (GREEDY/SELECTIVE/FILE)");
    return;
  }
  if(!parseArgs()){
    println("Parsing argument error;");
    return;
  }

  PImage img = loadImage(INPUTFILENAME);

  //get the parts from the file
  ArrayList<Integer> parts =  getParts(img);

  //decode it or save it to a file
  if (hasOutputFile) {
  //println("SAVING OUTPUT: " + OUTPUTFILENAME);
    if (MODE == FILE) {
      byte[] nums = getBytes(parts);
      saveBytes(OUTPUTFILENAME, nums);
    } else {
      String decodedMessage = decode(parts);
      String[] lines = {decodedMessage};
      saveStrings(OUTPUTFILENAME, lines);
    }
  } else {
    println(decode(parts));
  }
}

void draw(){
   exit();
}


boolean parseArgs(){
  if (args != null) {
    for (int i = 0; i < args.length; i++){

      if(args[i].equals("-iI")){
        try{
          INPUTFILENAME=args[i+1];
        }catch(Exception e){
          println("-iI requires filename as next argument");
          return false;
        }
      }

      if(args[i].equals("-oI")){
        hasOutputFile = true;
        if(args[i+1]!=null){
          OUTPUTFILENAME=args[i+1];
          if (MODE == FILE && OUTPUTFILENAME.endsWith(".txt")) {
            println("WARNING: Saving binary data to a .txt file may not be readable.");
          }
        }else{
          println("-oI requires filename as next argument");
          return false;
        }
      }


      if(args[i].equals("-b")){
        if(args[i+1]!=null){
          BYTE_COUNT=Integer.parseInt(args[i+1]);
        }else{
          println("-b requires an int as the next argument");
          return false;
        }
      }

      if(args[i].equals("-m")){
        if(args[i+1]!=null){
          String modeString=args[i+1];
          if(modeString.equalsIgnoreCase("greedy")){
              MODE = GREEDY;
          }else if(modeString.equalsIgnoreCase("selective")){
              MODE = SELECTIVE;
          }else if(modeString.equalsIgnoreCase("file")){
              MODE = FILE;
          }else{
            println("Invalid mode choice, defaulting to Greedy");
            MODE = GREEDY;
          }

        }else{
          println("-m requires mode as next argument");
          return false;
        }
      }
    }
  }
  return true;
}
