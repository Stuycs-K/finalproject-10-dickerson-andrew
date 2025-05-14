import java.util.Arrays;
int DEFAULT = 0;
int DIFF = 1;
int DIFF_R = 2;
int DIFF_G = 3;
int DIFF_B = 4;

int MODE = DEFAULT;

String FILE1="cat.png";
String FILE2="modifiedCat.png";
PImage img1;
PImage img2;
PImage allDiff;
PImage redDiff;
PImage blueDiff;
PImage greenDiff;

//Your goal:
//Write the command that updates img1 based on the mode
void updateScreen(){
  img1.loadPixels();
  img2.loadPixels();
  redDiff.loadPixels();
  greenDiff.loadPixels();
  blueDiff.loadPixels();


  if(MODE==DEFAULT){
    //default does nothing to the image
    println("DEFAULT");
    img1.updatePixels();
    image(img1, 0, 0);
  }else if(MODE==DIFF){
    //change the image to purple pixels where needed
    println("DIFF");
    allDiff.updatePixels();
    image(allDiff, 0, 0);
  }else if(MODE==DIFF_R){
    //change the image to red pixels where needed
    println("DIFF_R");
    redDiff.updatePixels();
    image(redDiff, 0, 0);
  }else if(MODE==DIFF_G){
    //change the image to green pixels where needed
    println("DIFF_G");
    greenDiff.updatePixels();
    image(greenDiff, 0, 0);
  }else if(MODE==DIFF_B){
    //change the image to blue pixels where needed
    println("DIFF_B");
    blueDiff.updatePixels();
    image(blueDiff, 0, 0);
  }

}


void settings() {
  if(args==null){
    println("no arguments provided");
    println("flags: -m MODIFIEDFILENAME -o ORIGINALFILENAME");
    return;
  }
  if(!parseArgs()){
    println("Parsing argument error;");
    return;
  }
  println("FILE1: "+FILE1);
  println("FILE2: "+FILE2);
  img1 = loadImage(FILE1);
  img2 = loadImage(FILE2);
  size(img1.width, img1.height);

}


void setup() {
  img1 = loadImage(FILE1);
  img2 = loadImage(FILE2);
  
  allDiff = createImage(img1.width, img1.height, RGB);
  redDiff = createImage(img1.width, img1.height, RGB);
  blueDiff = createImage(img1.width, img1.height, RGB);
  greenDiff = createImage(img1.width, img1.height, RGB);
  
  updateScreen();
    
  findImgDiff(img1, img2);
}


void draw(){
    //this is needed for keyPressed
}

void keyPressed(){
  MODE++;
  MODE%=5;
  updateScreen();
}

void findImgDiff(PImage img1, PImage img2){
  for (int i = 0; i < img1.width*img1.height; i++) {
    int r1 = (int)red(img1.pixels[i]);
    int g1 = (int)green(img1.pixels[i]);
    int b1 = (int)blue(img1.pixels[i]);
  
    int r2 = (int)red(img2.pixels[i]);
    int g2 = (int)green(img2.pixels[i]);
    int b2 = (int)blue(img2.pixels[i]);

    if (r1 != r2){
      redDiff.pixels[i]=color(255, 0, 0); 
      allDiff.pixels[i]=color(255, 0, 255);
    }
    if (g1 != g2){
      greenDiff.pixels[i]=color(0, 255, 0); 
      allDiff.pixels[i]=color(255, 0, 255);
    }
    if (b1 != b2){
      blueDiff.pixels[i]=color(0, 0, 255); 
      allDiff.pixels[i]=color(255, 0, 255);
    }

  }
}

boolean parseArgs(){
  if (args != null) {
    for (int i = 0; i < args.length; i++){


      if(args[i].equals("-o")){
        if(args[i+1]!=null){
          FILE1=args[i+1];
        }else{
          println("-o requires filename as next argument");
          return false;
        }
      }

      if(args[i].equals("-m")){
        if(args[i+1]!=null){
          FILE2=args[i+1];


        }else{
          println("-m requires mode as next argument");
          return false;
        }
      }
    }
  }
  return true;
}

// make diff ARGS="-m cat.png -o modifiedCat.png"
// make diff ARGS="-m catTwo.png -o catTwoSelective.png"
// make diff ARGS="-m space_modified.png -o space_og.png"
