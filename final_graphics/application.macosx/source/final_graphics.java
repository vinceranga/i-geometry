import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import oscP5.*; 
import netP5.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class final_graphics extends PApplet {

PGraphics pg;
int num_shapes = 7;
int times[] = new int[num_shapes];
int wait = 1000;
int w = 1680; int h = 1050;
int param[][] = new int[num_shapes][8];
int path[][] = new int[num_shapes][8];
int prev_path[][] = new int[num_shapes][8];
int ns[] = {-1, -1, -1, -1, -1, -1, -1};
int stage = 0;
int level = 1;
float vol;
int bf = 0;
int bf_timer;

// int colors[][] = { {153, 51, 51},  {255, 51, 0},  {255, 153, 0},  {204, 204, 0},  {0, 153, 51},  {0, 153, 153},  {0, 0, 153},  {102, 102, 153},  {102, 0, 102} };



  
OscP5 oscP5;
NetAddress myRemoteLocation;

public void setup() {
  
  // frameRate(25);
  
  pg = createGraphics(w/2, h/2);
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this, 12000);
  
  /* myRemoteLocation is a NetAddress. a NetAddress takes 2 parameters,
   * an ip address and a port number. myRemoteLocation is used as parameter in
   * oscP5.send() when sending osc packets to another computer, device, 
   * application. usage see below. for testing purposes the listening port
   * and the port of the remote location address are the same, hence you will
   * send messages back to this sketch.
   */
  myRemoteLocation = new NetAddress("127.0.0.1",12000);
}

public void build_tri(int cx, int cy, int r) {
  r = PApplet.parseInt(0.75f * r);
  triangle(cx, cy - r, cx + PApplet.parseInt(r * (sqrt(3) / 2.0f)), cy + PApplet.parseInt(r / 2.0f), cx - PApplet.parseInt(r * (sqrt(3) / 2.0f)), cy + PApplet.parseInt(r / 2.0f));
}

public void set_fill(int shape_n, int i, int j, int[] path, int[] n_param, int[] hit, int[] prev, int n) {
  if (i == (n%8) && j == (path[i] + n_param[i] - 1)/2) {
    int aim[] = {0, 0, 0};
    int dur = 150;
    int time = times[shape_n];
    for (int k = 0; k < 3; k++) {
      aim[k] = 255 + PApplet.parseInt(PApplet.parseFloat(min(dur, millis() - time)) / PApplet.parseFloat(dur) * PApplet.parseFloat(hit[k] - 255));
    }
    if (shape_n == 1 || shape_n == 3) fill(aim[1], aim[0] - 40, aim[2] - 40);
    else fill(aim[0], aim[1], aim[2]);
  }
  else if (i < n  &&  ((i > (n%8)  &&  j == (prev_path[shape_n][i] + n_param[i] - 1)/2)  ||  (i < (n%8)  &&  j == (path[i] + n_param[i] - 1)/2))){
    if (shape_n == 1 || shape_n == 3) fill(prev[1] + 25 * ((n - i) % 8), prev[0] - 40, prev[2] - 40);
    else fill(prev[0], prev[1] + 25 * ((n - i) % 8), prev[2]);
  }
  else fill(255);
}


public void tess(int shape_n, int cx, int cy, int dist, int r) {
  int n = ns[shape_n];
  int[] cparam = param[shape_n];
  int[] n_param = new int[cparam.length + 1];
  n_param[0] = 1;
  for (int i = 0; i < cparam.length; i++) {
    n_param[i+1] = n_param[i] + cparam[i];
  }

  int len = n_param.length;
  int start_h = cy - dist * (len - 1) / 2;
  for (int i = 0; i < len-1; i++) {
    int start_w = cx - PApplet.parseInt(2 / sqrt(3) * PApplet.parseFloat(dist * (n_param[i] - 1) / 2));
    for (int j = 0; j < n_param[i]; j++) {
      int hit[] = {255, 0, 255};
      int prev[] = {255, 77, 255};
      
      set_fill(shape_n, i, j, path[shape_n], n_param, hit, prev, n);
      
      if (shape_n == 1 || shape_n == 3) rect(start_w + PApplet.parseInt(2 / sqrt(3) * PApplet.parseFloat(dist * j)) - PApplet.parseInt(r/2.0f), start_h + dist * i - PApplet.parseInt(r/2.0f), r, r, PApplet.parseInt(0.2f * r));
      else if (level == 1) ellipse(start_w + PApplet.parseInt(2 / sqrt(3) * PApplet.parseFloat(dist * j)), start_h + dist * i, r, r);
      else if (level == 2) build_tri(start_w + PApplet.parseInt(2 / sqrt(3) * PApplet.parseFloat(dist * j)), start_h + dist * i, r);
      
      if (i == 0) {
        if (n < 8) fill(255);
        if (shape_n == 1 || shape_n == 3) rect(start_w - PApplet.parseInt(r/2.0f), start_h + dist * 8 - PApplet.parseInt(r/2.0f), r, r, PApplet.parseInt(0.2f * r));
        else if (level == 1) ellipse(start_w, start_h + dist * 8, r, r);
        else if (level == 2) build_tri(start_w, start_h + dist * 8, r); 
      }
    }
  }
}


public void draw() {
  if (bf == 1) fill(82 * min(1, (millis() - bf_timer) / 2000.0f), 0, 204 * min(1, (millis() - bf_timer) / 2000.0f));
  else if (bf == 2) fill(82 * (1 - min(1, (millis() - bf_timer) / 2000.0f)), 0, 204 * (1 - min(1, (millis() - bf_timer) / 2000.0f)));
  else fill(0);
  
  rect(0, 0, width, height);
  fill(204, 255, 255);
  noStroke();
  
  pg.beginDraw();
  pg.background(51);
  pg.noFill();
  pg.stroke(255);
  pg.endDraw();
  
  if (1 <= stage && stage <= 4) {
    tess(0, w/2, h/2, 100, PApplet.parseInt(vol * 30.0f));
  }
  if (2 <= stage && stage <= 5) {
    tess(1, w/6, h/2, 60, PApplet.parseInt(vol * 18.0f));
    tess(2, 5*w/6, h/2, 60, PApplet.parseInt(vol * 18.0f));
  }
  if (3 <= stage && stage <= 6) {
    tess(3, 3*w/10 + 10, h/5 + 10, 35, PApplet.parseInt(vol * 11.0f));
    tess(6, 7*w/10 - 10, 4*h/5 - 10, 35, PApplet.parseInt(vol * 11.0f));
  }
  if (4 <= stage && stage <= 7) {
    tess(4, 3*w/10 + 10, 4*h/5 - 10, 35, PApplet.parseInt(vol * 11.0f));
    tess(5, 7*w/10 - 10, h/5 + 10, 35, PApplet.parseInt(vol * 11.0f));
  }
}


/* incoming osc message are forwarded to the oscEvent method. */
public void oscEvent(OscMessage om) {
  if(om.checkAddrPattern("bf")==true) {
    if(om.checkTypetag("i")) {
      bf = om.get(0).intValue();
      bf_timer = millis();
      return;
    }
  }
  
  if(om.checkAddrPattern("level")==true) {
    if(om.checkTypetag("i")) {
      level = om.get(0).intValue();
      return;
    }
  }
  
  if(om.checkAddrPattern("vol")==true) {
    if(om.checkTypetag("f")) {
      vol = om.get(0).floatValue();
      return;
    }
  }
  
  if(om.checkAddrPattern("shape")==true) {
    if(om.checkTypetag("iiiiiiiii")) {
      int which = om.get(8).intValue();
      for (int k = 0; k < 8; k++) {
        param[which][k] = om.get(k).intValue();
      }
      return;
    }  
    
  } else if(om.checkAddrPattern("path")==true) {
    if(om.checkTypetag("iiiiiiiii")) {
      int which = om.get(8).intValue();
      for (int k = 0; k < 8; k++) {
        prev_path[which][k] = path[which][k];
        path[which][k] = om.get(k).intValue();
      }
      return;
    }  
  } else if(om.checkAddrPattern("time")==true) {
    if(om.checkTypetag("i")) {
      int which = om.get(0).intValue();
      // print(which + "\n");
      ns[which]++;
      times[which] = millis();
      redraw();
      return;
    }
  } else if(om.checkAddrPattern("stage")==true) {
    if(om.checkTypetag("i")) {
      stage = om.get(0).intValue();
      return;
    }
  } 
}
  public void settings() {  size(1680, 1050); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--present", "--window-color=#666666", "--hide-stop", "final_graphics" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
