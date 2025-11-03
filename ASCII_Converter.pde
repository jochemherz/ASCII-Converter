import gifAnimation.*;

//name of the file being converted (remember to add it to the sketch, too)
String fileName = "glsl.gif";

Gif gif;
PImage image;
boolean usingGif = false;
float maxwidth = 1200; float maxheight = 1000;

//params to play around with
String str = "   .,\":ii))((oojjmm00GQQÑÑ@";         //change the string to your liking!
float fontsize = 10;                                 //at the moment only changes the spacing
float blur = 200;                                    //blur amount: 0 - 255
boolean wave = false;                                //set to true for a wavelike effect
float wavePower = 5;                                 //wave amplitude
float waveSpeed = TWO_PI/100;                        //wave frequency



//resizing the window to fit the resized image
void settings(){
  image = loadImage(fileName);
  imageResize(image);
  size(image.width, image.height);
}


void setup(){
  background(0);
  noStroke();
  imageMode(CENTER);
  
  //initialize the image properties
  if(fileName.endsWith(".gif")){
    usingGif = true;
    gif = new Gif(this, fileName);
    imageResize(gif);
    gif.play();
  } else { //draw the still image
    drawASCII(image);
  }
}


void draw(){
  if(usingGif){ //draw the current frame of the GIF each frame
    drawASCII(gif);
  }
}


void imageResize(PImage img){
  while(img.width > maxwidth || img.height > maxheight){
    img.resize(img.width/2, img.height/2);
  }
}


void drawASCII(PImage image){
  
  //draw background
  fill(0, 255-blur);
  rect(0, 0, width, height);
  
  //for each cell of the grid...
  image.loadPixels();
  for(int y=0; y<image.height/fontsize; y++){
    for(int x=0; x<image.width/fontsize; x++){
      
      //get the individual color values
      var index = image.pixels[int(y*image.width*fontsize + x*fontsize + fontsize/2)];
      var red = red(index); 
      var green = green(index); 
      var blue = blue(index);
      var value = brightness(index); 
      value = (.2126 * red + .7152 * green + .0722 * blue);     //sRGB weighted luminance
      
      value = floor(value/255*(str.length()-1));                //get the correlated ASCII character
     
     float w = 0;
      if(wave){
        w = wavePower * sin( (x+y) * waveSpeed + frameCount/10);
      } else {
        w = 0;
      }
      
      fill(index); //index for original color, 255 for white
          
      text(str.charAt(int(value)), x*fontsize + (width-image.width)/2, y*fontsize + (height-image.height)/2 + w);
      
      //var l = value/255;
      //ellipse(x*fontsize + (width-image.width)/2, y*fontsize + (height-image.height)/2 + w, fontsize*l, fontsize*l);
    }
  }
}
