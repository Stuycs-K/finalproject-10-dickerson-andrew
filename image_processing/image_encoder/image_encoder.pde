import java.util.Arrays;
import java.io.File;  // Import the File class
import java.io.FileNotFoundException;  // Import this class to handle errors
import java.util.Scanner; // Import the Scanner class to read text files

final static int GREEDY = 0;
final static int SELECTIVE = 1;
final static int FILE = 2;

//default settings
int MODE = GREEDY;
String PLAINTEXT = "This";
String DISPLAYMODE = "false";
String INPUTFILENAME="";
String OUTPUTFILENAME="encoded.png";
PImage img; 
//the parseArgs function will set these to non-defaults

void draw(){
  if(DISPLAYMODE.equalsIgnoreCase("false")){
    exit();
    return;
  }
}

String loadTextFromFile(String filepath) {
  StringBuilder content = new StringBuilder();
  try {
    File file = new File(filepath);
    Scanner reader = new Scanner(file);
    while (reader.hasNextLine()) {
      content.append(reader.nextLine()).append("\n");
    }
    reader.close();
  } catch (FileNotFoundException e) {
    println("Couldn't open file " + filepath);
    e.printStackTrace();
  }
  return content.toString().trim();
}

void setup() {
  //println("(DEBUG) Working directory: " + new File(".").getAbsolutePath());
  if (args == null || !parseArgs()) {
    println("Invalid or missing arguments.");
    println("Usage: -iI input.png -oI output.png -p 'message_here' -dI true -m MODE");
    exit();
  return;
  }

  if (INPUTFILENAME.equals("")) {
    img = createImage(100, 100, RGB);
  for (int i = 0; i < img.pixels.length; i++) {
    img.pixels[i] = color(255, 255, 255);
  }
    img.updatePixels();
  } else {
    img = loadImage(INPUTFILENAME);
    if (img == null) {
      println("ERROR: Invalid input image: " + INPUTFILENAME);
      exit();
      return;
    }
  }

  int[] parts = messageToArray(PLAINTEXT);
  if (PLAINTEXT.isEmpty() && parts.length == 0) {
    println("INFO: Message is empty. Output image will be unchanged.");
  }
  
  if (!checkImageCapacity(img, parts)) {
    exit();
    return;
  }
  
  modifyImage(img, parts);
  img.save(OUTPUTFILENAME);

  if (DISPLAYMODE.equalsIgnoreCase("true")) {
    size(img.width, img.height);
    image(img, 0, 0);
  } else {
    exit();
  }
}

void settings() {
  PImage temp;
  if (args != null && parseArgs()) {
    if (INPUTFILENAME.equals("")) {
      size(100, 100);
    } else {
      temp = loadImage(INPUTFILENAME);
      size(temp.width, temp.height);
    }
  } else {
  size(1200, 600);
  }
}

boolean parseArgs() {
  for (int i = 0; i < args.length; i++) {
    if (args[i].equals("-iI")) {
      try {
        String potentialPath = args[++i];
        File f = new File(potentialPath);
        if (f.exists() && f.isFile()) {
          //println("(DEBUG) Using file path for input.");
          INPUTFILENAME = potentialPath;
        } else {
          println("WARNING: Invalid file path or file does not exist. Defaulting to plain text.");
          //println("(DEBUG) Current directory: "+System.getProperty("user.dir"));
          INPUTFILENAME = "";
        }
      } catch(Exception e) {
        println("-iI requires image file path as next argument.");
        return false;
      }
    }
    if (args[i].equals("-oI")) {
      try { 
      OUTPUTFILENAME = args[++i];
      } catch(Exception e) {
        println("-oI requires .wav file path as next argument.");
        return false;
      }
    }
    if (args[i].equals("-p")) {
      try {
        String potentialPath = args[++i];
        File f = new File(potentialPath);
        if (f.exists() && f.isFile()) {
          //println("(DEBUG) Using file path for input.");
          PLAINTEXT = loadTextFromFile(potentialPath);
        } else {
          //println("(DEBUG) Using string literal for input.");
          PLAINTEXT = potentialPath;
        }
      } catch(Exception e) {
        println("-p requires plain text or text file path as next argument.");
        return false;
      }
    }
    if (args[i].equals("-dI")) {
      try { 
      DISPLAYMODE = args[++i];
      } catch(Exception e) {
        println("-dI requires boolean (True/False) as next argument");
        return false;
      }
    }
    if (args[i].equals("-m")) {
      try { 
      String mode = args[++i].toLowerCase();
        if (mode.equals("greedy")) {
          MODE = GREEDY;
        } else if (mode.equals("selective")) {
           MODE = SELECTIVE;
        } else if (mode.equals("file")) {
          MODE = FILE;
        } else {
          println("Invalid mode, defaulting to GREEDY.");
          MODE = GREEDY;
        }
      } catch(Exception e) {
        println("-m requires mode (greedy/selective/file) as next argument.");
        return false;
      }
    }
  }
  return (PLAINTEXT != null && PLAINTEXT.length() > 0);
}

void modifyImage(PImage img, int[]messageArray) {
  //int usable_pixels = 0;
  //load the image into an array of pixels.
  img.loadPixels();
  //You can use img.pixels[index] to access this array

  if (MODE == GREEDY) {
    //GREEDY mode : use each pixel in order until you are done with the message.
    //Loop over the pixels in order. For each pixel:
    //-Take the next array value and write it to the red channel of the pixel.
    //-When there are no more letters, write a terminating character.
    //This means 4 pixels will store 1 char value from your String.
    //The terminating character is the value 255.
    //Note: (255 is 11111111b and 11b is just 3, make the last
    //four pixels store {3,3,3,3}
    for (int i = 0; i < (img.width * img.height) && i < messageArray.length; i++) {
      int r = (int) red(img.pixels[i]);
      int g = (int) green(img.pixels[i]);
      int b = (int) blue(img.pixels[i]);

      int encodedRed = r & 0xFC;
      int messageBits = messageArray[i]; 
      encodedRed = encodedRed | messageBits;
      img.pixels[i] = color(encodedRed, g, b);
    }

    int start = messageArray.length;
    for (int i = 0; i < 4; i++) {
      int index = start + i;
      if (index >= img.pixels.length) {
        println("Not enough space in provided image to add termination sequence.");
        break;
      }
      img.pixels[index] = color(3, 3, 3);
    }
  } else if (MODE == SELECTIVE || MODE == FILE) {
    //SELECTIVE MODE: only use a few pixels based on some criteria
    //when the red and green end in 00, modify the last 2 bits of blue with the bit value.
    //e.g.   if the pixel is r = 1100 ,g=1100 and blue=11xy, replace the xy in the blue with the next message value.
    //To terminate the message:
    //when no more message is left to encode, change all the remaining red values that end in 00 to 01.
    //This means the number of pixels that qualify for decoding will be a multiple of 4.
    int messageIndex = 0;
    
    for (int i = 0; i < (img.width*img.height); i++) {
      int r = (int)red(img.pixels[i]);
      int g = (int)green(img.pixels[i]);
      int b = (int)blue(img.pixels[i]);
      
      String redBinaryString = String.format("%8s", Integer.toBinaryString(r)).replace(" ", "0");
      String lastPairRed = redBinaryString.substring(redBinaryString.length() - 2);
      String greenBinaryString = String.format("%8s", Integer.toBinaryString(g)).replace(" ", "0");
      String lastPairGreen = greenBinaryString.substring(greenBinaryString.length() - 2);
     
      if (lastPairRed.equals("00") && lastPairGreen.equals("00")){
        //usable_pixels++;
        if (messageIndex < messageArray.length) {
          int encodedBlue = b & 0xFC;
          int messageBit = messageArray[messageIndex]; 
          encodedBlue = encodedBlue | (messageBit & 0x03);
          //println((DEBUG) String.format("%8s", Integer.toBinaryString(encodedBlue)).replace(" ", "0"));
          //println((DEBUG) messageArray[messageIndex]);
          img.pixels[i] = color(r, g, encodedBlue);
          messageIndex++;
        } else if (messageIndex >= messageArray.length) {
          img.pixels[i] = color(1, g, b);
        }
      }
 
    }
  }

  //write the pixel array back to the image.
  //println((DEBUG) +"Usable Pixels: "+usable_pixels);
  img.updatePixels();
}

int [] messageToArray(String s) {
  int[]parts = new int[s.length() * 4]; //optionally include the terminating character here.
  int partIndex = 0;
  
  for (int i = 0; i < s.length(); i++){
    int binaryChar = (int)s.charAt(i);
    String binaryString = Integer.toBinaryString(binaryChar);
    
    while (binaryString.length() < 8){
      binaryString = "0" + binaryString;
    }
    
    for (int j = 0; j < binaryString.length(); j+=2){
      String binaryTwo = binaryString.substring(j, j + 2);
      parts[partIndex++] = Integer.parseInt(binaryTwo,2);
    }
  }
  //calculate the array


  /**Verify the contents of the array before you do more.
   'T' -> 01010100 -> 01 01 01 00 -> 1, 1, 1, 0
   'h' -> 01101000 -> 01 10 10 00 -> 1, 2, 2, 0
   'i' -> 01101001 -> 01 10 10 01 -> 1, 2, 2, 1
   's' -> 01110011 -> 01 11 00 11 -> 1, 3, 0, 3
   ...etc.
   So your data array would look like this:
   { 1, 1, 1, 0, 1, 2, 2, 0, 1, 2, 2, 1, 1, 3, 0, 3...}
   */
  //println((DEBUG) Arrays.toString(parts));
  return parts;
}

int []fileToArray(String filename) {
  String content = "";
  try {
    File msgFile = new File(filename);
    Scanner reader = new Scanner(msgFile);
    while (reader.hasNextLine()) {
      content += reader.nextLine();
    }
    reader.close();
  } catch (FileNotFoundException e) {
      System.out.println("An error occurred.");
      e.printStackTrace();
    }
  return messageToArray(content);
}

boolean checkImageCapacity(PImage image, int[] messageArray) {
  long requiredSlots = messageArray.length;
  long requiredBits = requiredSlots * 2;

  image.loadPixels(); 

  if (image.pixels == null || image.pixels.length == 0) {
    println("ERROR: Image has no pixel data or pixels not loaded. Width: " + image.width + ", Height: " + image.height);
    if (image.width <= 0 || image.height <= 0) {
      println("ERROR: Image dimensions are invalid. Input file might be missing or corrupted.");
    }
    return false;
  }

  if (MODE == GREEDY) {
    long totalPixelSlots = (long)image.width * image.height;
    long slotsForTermination = 4;
    long availableSlotsForMessage = totalPixelSlots - slotsForTermination;
    long availableBitsForMessage = availableSlotsForMessage * 2;

    if (requiredBits > availableBitsForMessage) {
      println("ERROR: The message is too large to embed in the provided image using GREEDY mode.");
      //println("(DEBUG) Bits required for message: " + requiredBits + " (" + requiredSlots + " 2-bit parts)");
      //println("(DEBUG) Bits available in image (excluding termination): " + availableBitsForMessage + " (" + availableSlotsForMessage + " 2-bit parts)");
      //println("(DEBUG) Total image pixels: " + totalPixelSlots + ". Pixels for termination: " + slotsForTermination);
      return false;
    }
  } else if (MODE == SELECTIVE || MODE == FILE) {
    long usablePixelSlots = 0;
    for (int i = 0; i < image.pixels.length; i++) {
      int r = (int)red(image.pixels[i]);
      int g = (int)green(image.pixels[i]);
      if ((r & 0x03) == 0 && (g & 0x03) == 0) {
        usablePixelSlots++;
      }
    }
    
    long availableSlotsForMessage = usablePixelSlots;
    long availableBitsForMessage = availableSlotsForMessage * 2;

    if (requiredBits > availableBitsForMessage) {
      println("ERROR: The message is too large to embed in the provided image using SELECTIVE/FILE mode.");
      //println("(DEBUG) Bits required for message: " + requiredBits + " (" + requiredSlots + " 2-bit parts)");
      //println("(DEBUG) Bits available in qualifying pixels: " + availableBitsForMessage + " (" + availableSlotsForMessage + " 2-bit parts)");
      //println("(DEBUG) Total image pixels: " + image.pixels.length + ". Qualifying pixels found: " + usablePixelSlots);
      return false;
    }
    if (usablePixelSlots == 0 && requiredSlots > 0) {
      println("ERROR: No qualifying pixels found in the image for SELECTIVE/FILE mode, but message is not empty.");
      //println("(DEBUG) Bits required for message: " + requiredBits + " (" + requiredSlots + " 2-bit parts)");
      return false;
    }
  }
  return true;
}
