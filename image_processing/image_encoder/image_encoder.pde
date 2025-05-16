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
String INPUTFILENAME="dark.png";
String OUTPUTFILENAME="encoded.png";
PImage img; 
//the parseArgs function will set these to non-defaults

void draw(){
  if(DISPLAYMODE.equalsIgnoreCase("false")){
    exit();
    return;
  }
}

void setup() {
  size(1200, 600);

  if(args==null){
    println("no arguments provided");
    println("flags: -i INPUTFILENAME -o OUTPUTFILENAME -p PLAINTEXT (text or filename depending on mode) -d DISPLAYMODE (true/false) -m MODE (GREEDY/SELECTIVE/FILE)");
    return;
  }

  if(!parseArgs()){
    println("Parsing argument error;");
    return;
  }

  //println("Attempting to load image.");
  if(INPUTFILENAME.equals("dark.png")){
    img = createImage(width, height, RGB);
    img.loadPixels();
    for (int i = 0; i < img.pixels.length; i++) {
      img.pixels[i] = color(0, 0, 0); 
    }
    img.loadPixels();
    save("dark.png");
  }else{
    img = loadImage(INPUTFILENAME);
  }

  //2. Write the MESSAGETOARRAY method
  //convert the string into an array of ints in the range 0-3
  //println("Attempting to create part array.");
  int parts[];
  if(MODE==FILE){
    //in file mode, the plaintext is a filename
    parts = fileToArray(PLAINTEXT);
  }else{
    parts = messageToArray(PLAINTEXT);
  }

  //3. Write the MODIFY method.
  //println("Attempting to modify image.");
  modifyImage(img, parts);

  //save the modified image to disk.
  //println("Attempting to save image.");
  img.save(OUTPUTFILENAME);

  if(!DISPLAYMODE.equalsIgnoreCase("FALSE")){
    //println("Displaying image.");
    image(img,0,0);
  }
}

boolean parseArgs(){
  if (args != null) {
    for (int i = 0; i < args.length; i++){
      if(args[i].equals("-i")){
        try{
          INPUTFILENAME=args[i+1];
        }catch(Exception e){
          println("-o requires filename as next argument");
          return false;
        }
      }

      if(args[i].equals("-p")){
        try{
          PLAINTEXT=args[i+1];
        }catch(Exception e){
          println("-p requires quoted plaintext as next argument");
          return false;
        }
      }

      if(args[i].equals("-o")){
        if(args[i+1]!=null){
          OUTPUTFILENAME=args[i+1];
        }else{
          println("-o requires filename as next argument");
          return false;
        }
      }

      if(args[i].equals("-d")){
        if(args[i+1]!=null){
          DISPLAYMODE=args[i+1];
        }else{
          println("-d requires true/false as next argument");
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

    if (messageArray.length % 4 != 0) {
      int numRemainingPixels = 4 - (messageArray.length % 4);
      for (int i = messageArray.length; i < messageArray.length + numRemainingPixels; i++) {
        img.pixels[i] = color(3, 3, 3);
      }
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
          //println(String.format("%8s", Integer.toBinaryString(encodedBlue)).replace(" ", "0"));
          //println(messageArray[messageIndex]);
          img.pixels[i] = color(r, g, encodedBlue);
          messageIndex++;
        } else if (messageIndex >= messageArray.length) {
          img.pixels[i] = color(1, g, b);
        }
      }
 
    }
  }

  //write the pixel array back to the image.
  //println("Usable Pixels: "+usable_pixels);
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
  //println(Arrays.toString(parts));
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

// make encode ARGS="-i dark.png -o encoded.png -m GREEDY -d TRUE -p 'Oh look, a hidden message\!'"
// make encode ARGS="-i dark.png -o encoded.png -m GREEDY -d TRUE -p 'Oh look, a hidden message.'"

// make encode ARGS="-i dark.png -o outputSelective.png -m SELECTIVE -d TRUE -p 'Oh look, a hidden message!'"
// NUM_BITS = 344 for above msg
// make encode ARGS="-i dark.png -o outputSelectivePi.png -m GREEDY -d TRUE -p 'Oh look, a hidden message!'"

// make copy ARGS="encoded.png"
