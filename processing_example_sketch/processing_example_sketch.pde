/*
  The Processing + axidraw - Generative hut Tutorial by Julienv3ga
  With comments for explanation for our ECE471 Gen AI for Art and Arch Plotter Project Group.
*/

import processing.svg.*;
import java.util.*;
import controlP5.*;

ControlP5 cp5;
boolean bExportSVG = false;
String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}
// Default shape vertices, angles, radii, and shape proximities 
int nbPoints = 3;
float nbForms = 20;
float radiusMin = 10;
float radiusMax = 200;
float nbWaves = 2;
float angleRotation = 0.07;

// sets up the shape sliders that show up in the Processing environment
void initControls() {
  int hSlider = 18;
  int wSlider = width/2;
  int x = 5;
  int y = 5;
  int margin = 15;

  cp5 = new ControlP5(this);
  cp5.setAutoDraw(false);
  cp5.setBroadcast(false);

  cp5.addSlider("nbPoints").setSize(wSlider, hSlider).setPosition(x, y).setLabel("nb points").setRange(3, 10).setNumberOfTickMarks(10-3).setValue(nbPoints);
  y+=hSlider+margin;
  cp5.addSlider("nbForms").setSize(wSlider, hSlider).setPosition(x, y).setLabel("nb forms").setRange(1, 100).setNumberOfTickMarks(100).setValue(nbForms);
  y+=hSlider+margin;
  cp5.addRange("radius").setSize(wSlider, hSlider).setWidth(wSlider).setPosition(x, y).setLabel("radius range").setRange(10, 370).setRangeValues(radiusMin, radiusMax);
  y+=hSlider+margin;
  cp5.addSlider("nbWaves").setSize(wSlider, hSlider).setWidth(wSlider).setPosition(x, y).setLabel("nb waves").setRange(1, 5).setNumberOfTickMarks(5).setValue(nbWaves);
  y+=hSlider+margin;
  cp5.addSlider("angleRotation").setSize(wSlider, hSlider).setPosition(x, y).setLabel("rotation").setRange(0, PI/2).setValue(angleRotation);
  cp5.setBroadcast(true);
}

// Save the image as an .svg if you press e
void keyPressed() {
  if (key == 'e') {
    bExportSVG = true;
  }
}

//Size of canvas
void setup() {
  size(800, 800);
  initControls();
}

void draw() {
  background(255);
  
  if(bExportSVG) {
    beginRecord(SVG, "data/exports/svg/export_"+timestamp()+".svg");
  }
  
  noFill();
  stroke(0);
  pushMatrix();
  translate(width/2, height/2);
  
  // Centers the drawing and alters the rotation and shape based on the sliders
  for (int n=0; n < nbForms; n++) {
    pushMatrix();
    rotate( map( sin(nbWaves*n/(nbForms-1)*TWO_PI), -1, 1, -angleRotation, angleRotation) );
    circle(nbPoints, map(n, 0, nbForms-1, radiusMax, radiusMin));
    popMatrix();
  }
  
  popMatrix();
  
  if (bExportSVG) {
    endRecord();
    bExportSVG = false;
  }
  
  drawControls();
}

void circle(int nbPoints, float radius) {
  beginShape();
  for (int i = 0; i < nbPoints; i++){
    float angle = -PI/2+float(i)*TWO_PI/float(nbPoints);
    vertex(radius*cos(angle), radius*sin(angle));
  }
  endShape(CLOSE);
}

void controlEvent(ControlEvent theControlEvent) 
{
  if (theControlEvent.isFrom("radius")) 
  {
    radiusMin = int(theControlEvent.getController().getArrayValue(0));
    radiusMax = int(theControlEvent.getController().getArrayValue(1));
  }
}

// Line and style settings
void drawControls() 
{
  pushStyle();
  noStroke();
  fill(0, 100);
  rect(0, 0, width, 160);
  popStyle();
  cp5.draw();
}
