import processing.video.*;

Capture cam;

int yOld,yNew;
int[] camLine = new int[900]; // use only numbers that can be divided by 3 !!!!
int[] camLine2 = new int[900]; //use only numbers that can be divided by 3 !!!!
int der =0;
boolean derUp=false;
boolean derDown=false;
int [] line;
int ii=0;
int distance=0;
int wideLine=0;
int wideLinet=25;
int narrowLine=0;
int narrowLinetl=4;
int narrowLineth=15;
int[] sort;
boolean videoOnScreen=true;

void setup() 
{
  size(900, 900);  // use only numbers that can be divided by 3 !!!!
  textSize(200); 
  String[] cameras = Capture.list();
  
  while (cameras.length==0)
  {
  cameras = Capture.list();
  }
  
  if (cameras.length == 0) 
  {
    println("There are no cameras available for capture.");
    exit();
  } 
  else 
  {
    println("Available cameras:");
    
    for (int i = 0; i < cameras.length; i++) 
      println("[" + i + "] " +cameras[i]);
  }

  cam = new Capture(this, 900, 900, cameras[0]);  // use only numbers that can be divided by 3 !!!!
  cam.start();  
  
 }

void draw() 
{
  if (cam.available()) 
  {
    cam.read();
    cam.loadPixels();
    background(0); 
    noStroke();   
    
    if (videoOnScreen) 
    {
      set(0, 0, cam); 
    }

    noFill();
    stroke(255, 0, 0);  
    detection();
    lineWidth(der);
    drawing();
    display();
   //<>//
 }   
}  
    
void detection() 
    {
    int j = cam.height / 2;
    int i = cam.width / 2;
    int pixelColor = cam.pixels[j*cam.width + i];

    for (i=0; i<cam.width; i++)
    {
       pixelColor = cam.pixels[j*cam.width + i];
       camLine[i] = (int)brightness(pixelColor);  // 0 black, 255 white

       if (camLine[i]>=100){
       camLine[i]=255;
       camLine2[i]=1;
       }
       else{
       camLine2[i]=0;
       camLine[i]=0;
       }
       
       if(i>0)
       {
         if (camLine2[i]-camLine2[i-1]==1)
         {
         derDown=true;
         }
         
         if(camLine2[i]-camLine2[i-1]==-1)
         {       
         derUp=true;
         }
         
         if (derUp & derDown)
         {
         derUp=false;
         derDown=false;
         der=der+1;
         }
         
       }
                          
    } 
  }
  
void drawing()
    {
    for (int i=cam.width/3; i<2*cam.width/3; i++) {
       yNew = camLine[i]; 
       yNew = (int)map(yNew,0,255,120,0);    
       line(i-1,yOld,i,yNew);
       yOld=yNew;
    }
    line(cam.width/3,0,cam.width/3,900);
    line(2*cam.width/3,0,2*cam.width/3,900);
    
    line(cam.width/3,cam.height / 2+100,2*cam.width/3,cam.height / 2+100);
    line(cam.width/3,cam.height / 2-100,2*cam.width/3,cam.height / 2-100);
  }    
    
    
void lineWidth(int der)
    {
    int p=0;
    derDown=false;
    derUp=false;
    line =new int[der];
    sort=new int[der];
    ii=0;
    distance=0;
    wideLine=0;
    narrowLine=0;
 
    for (int i=cam.width/3; i<2*cam.width/3; i++)
    {
      if(i>0)
       {
         if(camLine2[i]-camLine2[i-1]==1)
         {
         derUp=true;
         }
         
         if(camLine2[i]-camLine2[i-1]==-1)
         {       
         derDown=true;
         }
         
         if (derDown==true & camLine2[i]==0 )
         {
         distance=distance+1;
         }
         
         if (derUp==true & camLine2[i]==1 & derDown==true)
         {
         if (distance>wideLinet)
         {
         wideLine=wideLine+1;
         sort[p]=0;
         p=p+1;
         }
         
         if (distance>narrowLinetl & distance<narrowLineth)
         {
         narrowLine=narrowLine+1;
         sort[p]=1;
         p=p+1;
         
         }
         
         if (distance<narrowLinetl)
         {
         
         for(int z=i;z==0;i--)
         {
         camLine[i]=0;
         }
         }
         
         line[ii]=distance;
         distance=0;
         derDown=false;
         ii=ii+1;
         }
                 
       }
    }
    
    }

void display()
    {
     
    if(narrowLine==0 & wideLine>0)
    {
      if (wideLine==1)
      {
      text('A',cam.width/2-50,cam.height/2+300);
      }
      
      if(wideLine==2)
      {
      text('B',cam.width/2-50,cam.height/2+300);
      }
      
      if(wideLine==3)
      {
      text('C',cam.width/2-50,cam.height/2+300);
      }
    }
      
    if (narrowLine==1 & wideLine==1) //<>//
    {
      if(sort[0]==0 & sort[1]==1)
      {
      text('D',cam.width/2-50,cam.height/2+300);
      }
    
      if(sort[0]==1 & sort[1]==0)
      {
      text('E',cam.width/2-50,cam.height/2+300);
      }
    }
    
    if (narrowLine==2 & wideLine==1)
    {
      if(sort[0]==1 & sort[1]==0 & sort[2]==1)
      {
      text('F',cam.width/2-50,cam.height/2+300);
      }
    
      if(sort[0]==1 & sort[1]==1 & sort[2]==0)
      {
      text('G',cam.width/2-50,cam.height/2+300);
      }
      
    }
    
    }
    
void keyPressed() 
{
  if  (key == 'c') 
    videoOnScreen = !videoOnScreen;
}
