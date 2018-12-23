/* --------------------------------------------------------
   i <| geometry
   Vince Ranganathan
   MUSIC 220B (Winter 2018)
-------------------------------------------------------- */

// name
"localhost" => string hostname;
12000 => int port;

// check command line
if( me.args() ) me.arg(0) => hostname;
if( me.args() > 1 ) me.arg(1) => Std.atoi => port;

// send object
OscSend xmit;

// aim the transmitter
xmit.setHost( hostname, port );

fun void open(SndBuf buf, string name) {
    me.dir() => string path;
    "/sounds/" + name + ".aif" => string filename;
    path+filename => filename;
    filename => buf.read;
}


SndBuf bass => Envelope bass_e => Gain bass_g => Pan2 bass_p => dac;
SndBuf flute => Envelope flute_e => Gain flute_g => Pan2 flute_p => dac;
SndBuf marimba => Envelope marimba_e => Gain marimba_g => Pan2 marimba_p => dac;
SndBuf marimba2 => Envelope marimba2_e => Gain marimba2_g => Pan2 marimba2_p => dac;
SndBuf piano => Envelope piano_e => Gain piano_g => Pan2 piano_p => dac;
SndBuf piano2 => Envelope piano2_e => Gain piano2_g => Pan2 piano2_p => dac;
SndBuf pluck => Envelope pluck_e => Gain pluck_g => Pan2 pluck_p => dac;

SndBuf d_kick => Envelope d_kick_e => Gain d_kick_g => Pan2 d_kick_p => dac;
SndBuf d_snare => Envelope d_snare_e => Gain d_snare_g => Pan2 d_snare_p => dac;
SndBuf d_snarelight => Envelope d_snarelight_e => Gain d_snarelight_g => Pan2 d_snarelight_p => dac;
SndBuf d_stick => Envelope d_stick_e => Gain d_stick_g => Pan2 d_stick_p => dac;
SndBuf d_tom => Envelope d_tom_e => Gain d_tom_g => Pan2 d_tom_p => dac;

SndBuf h_hat1 => Envelope h_hat1_e => Gain h_hat1_g => Pan2 h_hat1_p => dac;
SndBuf h_hat2 => Envelope h_hat2_e => Gain h_hat2_g => Pan2 h_hat2_p => dac;
SndBuf h_hatopen => Envelope h_hatopen_e => Gain h_hatopen_g => Pan2 h_hatopen_p => dac;
SndBuf h_ride => Envelope h_ride_e => Gain h_ride_g => Pan2 h_ride_p => dac;
SndBuf h_tambourine => Envelope h_tambourine_e => Gain h_tambourine_g => Pan2 h_tambourine_p => dac;

// [0.5946, 0.6674, 0.7492, 0.8909, 1.0000, 1.1892, 1.3343, 1.4983, 1.7818] @=> float pitches[];

2.0 => d_kick_g.gain;
1.5 => d_tom_g.gain;
1.2 => d_snare_g.gain;

3.0 => flute_g.gain;
0.45 => piano_g.gain;
1.2 => pluck_g.gain;
1.5 => h_tambourine_g.gain;

0.3 => piano_p.pan;
-0.3 => pluck_p.pan;

[d_snare, d_stick, d_tom, d_snarelight, d_kick, d_snarelight, d_tom, d_stick, d_snare] @=> SndBuf d_assignments[];
[d_snare_e, d_stick_e, d_tom_e, d_snarelight_e, d_kick_e, d_snarelight_e, d_tom_e, d_stick_e, d_snare_e] @=> Envelope d_assignments_e[];
[d_snare_p, d_stick_p, d_tom_p, d_snarelight_p, d_kick_p, d_snarelight_p, d_tom_p, d_stick_p, d_snare_p] @=> Pan2 d_assignments_p[];

[h_hatopen, h_hat1, h_ride, h_hat2, h_tambourine, h_hat2, h_ride, h_hat1, h_hatopen] @=> SndBuf h_assignments[];
[h_hatopen_e, h_hat1_e, h_ride_e, h_hat2_e, h_tambourine_e, h_hat2_e, h_ride_e, h_hat1_e, h_hatopen_e] @=> Envelope h_assignments_e[];
[h_hatopen_p, h_hat1_p, h_ride_p, h_hat2_p, h_tambourine_p, h_hat2_p, h_ride_p, h_hat1_p, h_hatopen_p] @=> Pan2 h_assignments_p[];

open(bass, "bass_1");
open(flute, "flute_1");
open(marimba, "marimba_1");
open(marimba2, "marimba_1");
open(piano, "piano_1");
open(piano2, "piano_1");
open(pluck, "pluck_1");

open(d_kick, "d_kick");
open(d_snare, "d_snare");
open(d_snarelight, "d_snarelight");
open(d_stick, "d_stick");
open(d_tom, "d_tom");

open(h_hat1, "h_hat1");
open(h_hat2, "h_hat2");
open(h_hatopen, "h_hatopen");
open(h_ride, "h_ride");
open(h_tambourine, "h_tambourine");

8 => int len;
[1, 1, 1, 1, -1, -1, -1, -1] @=> int shape_1[]; // one large diamond
[1, 1, -1, -1, 1, 1, -1, -1] @=> int shape_2[]; // two small diamonds
[1, 1, -1, 1, 1, -1, -1, -1] @=> int shape_3[]; // big under small
[1, -1, 1, -1, 1, -1, 1, -1] @=> int shape_4[]; // zipper

/* ---------------------------------
This is what the diamond (shape_1) looks like:

 -4  -3  -2  -1   0   1   2   3   4
                  o
                /   \
              o       o
            /   \   /   \
          o       o       o
        /   \   /   \   /   \
      o       o       o       o
    /   \   /   \   /   \   /   \
  o       o       o       o       o
    \   /   \   /   \   /   \   /
      o       o       o       o
        \   /   \   /   \   /
          o       o       o
            \   /   \   /
              o       o
                \   /
                  o

Here's an example of a randomly generated path, denoted by the asteriks (*):

                  *
                /   \
              *       o
            /   \   /   \
          *       o       o
        /   \   /   \   /   \
      o       *       o       o
    /   \   /   \   /   \   /   \
  o       *       o       o       o
    \   /   \   /   \   /   \   /
      *       o       o       o
        \   /   \   /   \   /
          *       o       o
            \   /   \   /
              *       o
                \   /
                  *
                  
All possible shapes are subsets of the diamond.
Some of the shapes are a bit more restricted, such as the zipper (shape_4):

                  o
                /   \
              o       o
                \   /
                  o
                /   \
              o       o
                \   /
                  o
                /   \
              o       o
                \   /
                  o
                /   \
              o       o
                \   /
                  o

Increasing the number of restrictions increases predictability, which can
be useful in some cases if a certain rhythm or tone is desired.

To create a path, we start at the top row at node 0.
If only left or right is available (moving down), we move to the available node.
If both are available, we pick randomly as follows:
-if at node 0, pick L with probability 0.5
-else if at node < 0, continue further L (i.e. pick L) with probability 0.75
-else (if at node > 0), continue further R (i.e. pick R) with probability 0.75
This encourages exploration of the edges rather than staying too close to the center.
--------------------------------- */


fun int rand_step(float p) {
    Math.randomf() => float rand;
    if (rand < p) return 1;
    else return -1;
}


fun int[] random_path(int shape[]) {
    1 => int n_nodes;
    0 => int curr_node;
    /*sizeof(shape) / sizeof(int)*/ len - 1 => int total;
    int path[total + 1];
    0 => path[0];
    
    for (0 => int count; count < total; count + 1 => count) {
        n_nodes + shape[count] => n_nodes;
        if (curr_node - 1 < -n_nodes) {
            curr_node + 1 => curr_node;
        } else if (curr_node + 1 > n_nodes) {
            curr_node - 1 => curr_node;
        } else {
            if (curr_node == 0) {
                curr_node + rand_step(0.5) => curr_node;
            } else if (curr_node < 0) {
                curr_node + rand_step(0.33) => curr_node;
            } else if (curr_node > 0) {
                curr_node + rand_step(0.67) => curr_node;
            }   
        }
        // <<< count, curr_node >>>;
        curr_node => path[count + 1];
    }
    
    return path;
}

1 => int counter;

fun void gen_sound(int which, string mode, int shape[], int len, int BPM, SndBuf buf, Envelope buf_e, Gain buf_g, Pan2 buf_p) {
    (30.0 / BPM)::second => dur quaver;
    
    random_path(shape) @=> int path[];
    
    xmit.startMsg("path", "iiiiiiiii");
    for (0 => int k; k < len; k+1 => k) {
        path[k] => xmit.addInt;
    }
    which => xmit.addInt;
    
    0 => int swing;
    
    for (0 => int k; k < len; k+1 => k) {
        xmit.startMsg("time", "i");
        which => xmit.addInt;
        0.1 * quaver => now;
        
        if (mode == "pentatonic") {
            
            (path[k] + 4) * 44100 => buf.pos;
            buf_e.keyOn();
            0.8 * quaver => now;
            buf_e.keyOff();
            0.1 * quaver => now;
            
        } else if (mode == "swing") {
            
            (path[k] + 4) * 44100 => buf.pos;
            buf_e.keyOn();
            if (swing == 0) 1.13 * quaver => now;
            else if (swing == 1) 0.47 * quaver => now;
            buf_e.keyOff();
            0.1 * quaver => now;
            (swing + 1) % 2 => swing;
            
        } else if (mode == "pentatonic-light") {
            
            (path[k] + 4) * 44100 => buf.pos;
            buf_e.keyOn();
            0.88 * quaver => now;
            buf_e.keyOff();
            0.02 * quaver => now;
            
        } else if (mode == "pentatonic-up") {
            
            xmit.startMsg("vol", "f");
            counter / (4.0 * len) => buf_g.gain;
            Math.min(1.0, counter / (4.0 * len)) => xmit.addFloat;
            
            (path[k] + 4) * 44100 => buf.pos;
            buf_e.keyOn();
            0.8 * quaver => now;
            buf_e.keyOff();
            0.1 * quaver => now;
            counter + 1 => counter;
            
        } else if (mode == "swing-up") {
            
            xmit.startMsg("vol", "f");
            Math.min(1.0, counter / (8.0 * len)) => xmit.addFloat;
            counter / (7.0 * len) => buf_g.gain;
            
            (path[k] + 4) * 44100 => buf.pos;
            buf_e.keyOn();
            if (swing == 0) 1.13 * quaver => now;
            else if (swing == 1) 0.47 * quaver => now;
            buf_e.keyOff();
            0.1 * quaver => now;
            
            (swing + 1) % 2 => swing;
            counter + 1 => counter;
            
        } else if (mode == "all_h") {
            
            path[k] / 4.5 => h_assignments_p[ path[k] + 4 ].pan;
            0 => h_assignments[ path[k] + 4 ].pos;
            h_assignments_e[ path[k] + 4 ].keyOn();
            0.9 * quaver => now;
            h_assignments_e[ path[k] + 4 ].keyOff();
            //0.1 * quaver => now;
            
        } else if (mode == "all_h-swing") {
            
            path[k] / 4.5 => h_assignments_p[ path[k] + 4 ].pan;
            0 => h_assignments[ path[k] + 4 ].pos;
            h_assignments_e[ path[k] + 4 ].keyOn();
            if (swing == 0) 1.23 * quaver => now;
            else if (swing == 1) 0.57 * quaver => now;
            h_assignments_e[ path[k] + 4 ].keyOff();
            //0.1 * quaver => now;
            
            (swing + 1) % 2 => swing;
            
        } else if (mode == "all_d") {
            
            path[k] / 4.5 => d_assignments_p[ path[k] + 4 ].pan;
            0 => d_assignments[ path[k] + 4 ].pos;
            d_assignments_e[ path[k] + 4 ].keyOn();
            0.9 * quaver => now;
            d_assignments_e[ path[k] + 4 ].keyOff();
            //0.1 * quaver => now;
            
        } else if (mode == "all_d-swing") {
            
            path[k] / 4.5 => d_assignments_p[ path[k] + 4 ].pan;
            0 => d_assignments[ path[k] + 4 ].pos;
            d_assignments_e[ path[k] + 4 ].keyOn();
            if (swing == 0) 1.23 * quaver => now;
            else if (swing == 1) 0.57 * quaver => now;
            d_assignments_e[ path[k] + 4 ].keyOff();
            //0.1 * quaver => now;
            
            (swing + 1) % 2 => swing;
        }
    }
}

// DOTS: change in size / color / position --> meaning in terms of music
// "Break some aspect of your setup"
// Few more elements along these lines^ ADVANCE THE NARRATIVE


fun void n_gen(int which, int n, string mode, int shape[], int len, int BPM, SndBuf buf, Envelope buf_e, Gain buf_g, Pan2 buf_p) {
    xmit.startMsg("shape", "i i i i i i i i i");
    for (0 => int k; k < 8; k+1 => k) {
        shape[k] => xmit.addInt;
    }
    which => xmit.addInt;
    
    for (0 => int k; k < n; k+1 => k) {
        spork ~ gen_sound(which, mode, shape, len, BPM, buf, buf_e, buf_g, buf_p);
        (len * 30.0 / BPM)::second => now;
    }
}


//n_gen(16, "pan", snare, snare_e, snare_g, snare_p, shape_1, len, 150); 

SndBuf _; Envelope _e; Gain _g; Pan2 _p;


2::second => now;

xmit.startMsg("bf", "i");
1 => xmit.addInt;

2::second => now;


xmit.startMsg("stage", "i");
1 => xmit.addInt;
        n_gen(0, 4, "pentatonic-up", shape_1, len, 62, bass, bass_e, bass_g, bass_p);


xmit.startMsg("stage", "i");
2 => xmit.addInt;
spork ~ n_gen(0, 4, "pentatonic", shape_1, len, 62, bass, bass_e, bass_g, bass_p);
spork ~ n_gen(1, 8, "all_h", shape_1, len, 124, _, _e, _g, _p);
        n_gen(2, 4, "pentatonic", shape_1, len, 62, marimba, marimba_e, marimba_g, marimba_p);


xmit.startMsg("stage", "i");
3 => xmit.addInt;
spork ~ n_gen(0, 4, "pentatonic", shape_1, len, 62, bass, bass_e, bass_g, bass_p);
spork ~ n_gen(1, 8, "all_h", shape_1, len, 124, _, _e, _g, _p);
spork ~ n_gen(2, 4, "pentatonic", shape_1, len, 62, marimba, marimba_e, marimba_g, marimba_p);
spork ~ n_gen(3, 8, "all_d", shape_1, len, 124, _, _e, _g, _p);
        n_gen(6, 16, "pentatonic", shape_1, len, 248, flute, flute_e, flute_g, flute_p);
        

xmit.startMsg("stage", "i");
4 => xmit.addInt;
spork ~ n_gen(0, 4, "pentatonic", shape_1, len, 62, bass, bass_e, bass_g, bass_p);
spork ~ n_gen(1, 8, "all_h", shape_1, len, 124, _, _e, _g, _p);
spork ~ n_gen(2, 4, "pentatonic", shape_1, len, 62, marimba, marimba_e, marimba_g, marimba_p);
spork ~ n_gen(3, 8, "all_d", shape_1, len, 124, _, _e, _g, _p);
spork ~ n_gen(4, 4, "pentatonic-light", shape_1, len, 62, pluck, pluck_e, pluck_g, pluck_p);
spork ~ n_gen(5, 8, "pentatonic-light", shape_1, len, 124, piano, piano_e, piano_g, piano_p);
        n_gen(6, 16, "pentatonic", shape_1, len, 248, flute, flute_e, flute_g, flute_p);

spork ~ n_gen(0, 2, "pentatonic", shape_4, len, 62, bass, bass_e, bass_g, bass_p);
spork ~ n_gen(1, 4, "all_h", shape_1, len, 124, _, _e, _g, _p);
spork ~ n_gen(2, 2, "pentatonic", shape_1, len, 62, marimba, marimba_e, marimba_g, marimba_p);
spork ~ n_gen(3, 4, "all_d", shape_1, len, 124, _, _e, _g, _p);
spork ~ n_gen(4, 2, "pentatonic-light", shape_1, len, 62, pluck, pluck_e, pluck_g, pluck_p);
spork ~ n_gen(5, 4, "pentatonic-light", shape_1, len, 124, piano, piano_e, piano_g, piano_p);
        n_gen(6, 8, "pentatonic", shape_1, len, 248, flute, flute_e, flute_g, flute_p);
        
spork ~ n_gen(0, 2, "pentatonic", shape_4, len, 62, bass, bass_e, bass_g, bass_p);
spork ~ n_gen(1, 4, "all_h", shape_4, len, 124, _, _e, _g, _p);
spork ~ n_gen(2, 2, "pentatonic", shape_4, len, 62, marimba, marimba_e, marimba_g, marimba_p);
spork ~ n_gen(3, 4, "all_d", shape_1, len, 124, _, _e, _g, _p);
spork ~ n_gen(4, 2, "pentatonic-light", shape_1, len, 62, pluck, pluck_e, pluck_g, pluck_p);
spork ~ n_gen(5, 4, "pentatonic-light", shape_1, len, 124, piano, piano_e, piano_g, piano_p);
        n_gen(6, 8, "pentatonic", shape_1, len, 248, flute, flute_e, flute_g, flute_p);
        
spork ~ n_gen(0, 1, "pentatonic", shape_4, len, 62, bass, bass_e, bass_g, bass_p);
spork ~ n_gen(1, 2, "all_h", shape_4, len, 124, _, _e, _g, _p);
spork ~ n_gen(2, 1, "pentatonic", shape_4, len, 62, marimba, marimba_e, marimba_g, marimba_p);
spork ~ n_gen(3, 2, "all_d", shape_4, len, 124, _, _e, _g, _p);
spork ~ n_gen(4, 1, "pentatonic-light", shape_1, len, 62, pluck, pluck_e, pluck_g, pluck_p);
spork ~ n_gen(5, 2, "pentatonic-light", shape_1, len, 124, piano, piano_e, piano_g, piano_p);
        n_gen(6, 4, "pentatonic", shape_4, len, 248, flute, flute_e, flute_g, flute_p);
        
spork ~ n_gen(0, 1, "pentatonic", shape_4, len, 62, bass, bass_e, bass_g, bass_p);
spork ~ n_gen(1, 2, "all_h", shape_4, len, 124, _, _e, _g, _p);
spork ~ n_gen(2, 1, "pentatonic", shape_4, len, 62, marimba, marimba_e, marimba_g, marimba_p);
spork ~ n_gen(3, 2, "all_d", shape_4, len, 124, _, _e, _g, _p);
spork ~ n_gen(4, 1, "pentatonic-light", shape_4, len, 62, pluck, pluck_e, pluck_g, pluck_p);
spork ~ n_gen(5, 2, "pentatonic-light", shape_4, len, 124, piano, piano_e, piano_g, piano_p);
        n_gen(6, 4, "pentatonic", shape_4, len, 248, flute, flute_e, flute_g, flute_p);


spork ~ n_gen(0, 1, "pentatonic", shape_4, len, 62, bass, bass_e, bass_g, bass_p);
spork ~ n_gen(1, 2, "all_h", shape_4, len, 124, _, _e, _g, _p);
spork ~ n_gen(2, 1, "pentatonic", shape_4, len, 62, marimba, marimba_e, marimba_g, marimba_p);
spork ~ n_gen(3, 2, "all_d", shape_3, len, 124, _, _e, _g, _p);
spork ~ n_gen(4, 1, "pentatonic-light", shape_4, len, 62, pluck, pluck_e, pluck_g, pluck_p);
spork ~ n_gen(5, 2, "pentatonic-light", shape_4, len, 124, piano, piano_e, piano_g, piano_p);
        n_gen(6, 4, "pentatonic", shape_3, len, 248, flute, flute_e, flute_g, flute_p);
        
spork ~ n_gen(0, 1, "pentatonic", shape_4, len, 62, bass, bass_e, bass_g, bass_p);
spork ~ n_gen(1, 2, "all_h", shape_4, len, 124, _, _e, _g, _p);
spork ~ n_gen(2, 1, "pentatonic", shape_4, len, 62, marimba, marimba_e, marimba_g, marimba_p);
spork ~ n_gen(3, 2, "all_d", shape_3, len, 124, _, _e, _g, _p);
spork ~ n_gen(4, 1, "pentatonic-light", shape_3, len, 62, pluck, pluck_e, pluck_g, pluck_p);
spork ~ n_gen(5, 2, "pentatonic-light", shape_3, len, 124, piano, piano_e, piano_g, piano_p);
        n_gen(6, 4, "pentatonic", shape_3, len, 248, flute, flute_e, flute_g, flute_p);
        
spork ~ n_gen(0, 1, "pentatonic", shape_4, len, 62, bass, bass_e, bass_g, bass_p);
spork ~ n_gen(1, 2, "all_h", shape_3, len, 124, _, _e, _g, _p);
spork ~ n_gen(2, 1, "pentatonic", shape_3, len, 62, marimba, marimba_e, marimba_g, marimba_p);
spork ~ n_gen(3, 2, "all_d", shape_3, len, 124, _, _e, _g, _p);
spork ~ n_gen(4, 1, "pentatonic-light", shape_3, len, 62, pluck, pluck_e, pluck_g, pluck_p);
spork ~ n_gen(5, 2, "pentatonic-light", shape_3, len, 124, piano, piano_e, piano_g, piano_p);
        n_gen(6, 4, "pentatonic", shape_3, len, 248, flute, flute_e, flute_g, flute_p);

spork ~ n_gen(0, 1, "pentatonic", shape_3, len, 62, bass, bass_e, bass_g, bass_p);
spork ~ n_gen(1, 2, "all_h", shape_3, len, 124, _, _e, _g, _p);
spork ~ n_gen(2, 1, "pentatonic", shape_3, len, 62, marimba, marimba_e, marimba_g, marimba_p);
spork ~ n_gen(3, 2, "all_d", shape_3, len, 124, _, _e, _g, _p);
spork ~ n_gen(4, 1, "pentatonic-light", shape_3, len, 62, pluck, pluck_e, pluck_g, pluck_p);
spork ~ n_gen(5, 2, "pentatonic-light", shape_3, len, 124, piano, piano_e, piano_g, piano_p);
        n_gen(6, 4, "pentatonic", shape_3, len, 248, flute, flute_e, flute_g, flute_p);


for (0 => int k; k < 30; k+1 => k) {
    xmit.startMsg("vol", "f");
    1.0 - (k / 30.0) => xmit.addFloat;
    (8.0 / 62.0)::second => now;
}
(120.0 / 62.0)::second => now;

xmit.startMsg("stage", "i");
0 => xmit.addInt;
xmit.startMsg("level", "i");
2 => xmit.addInt;
1 => counter;


xmit.startMsg("stage", "i");
1 => xmit.addInt;
        n_gen(0, 8, "swing-up", shape_1, len, 124, flute, flute_e, flute_g, flute_p);


xmit.startMsg("stage", "i");
2 => xmit.addInt;
spork ~ n_gen(0, 8, "swing", shape_1, len, 124, flute, flute_e, flute_g, flute_p);
spork ~ n_gen(1, 8, "all_d-swing", shape_1, len, 124, _, _e, _g, _p);
        n_gen(2, 4, "swing", shape_1, len, 62, pluck, pluck_e, pluck_g, pluck_p);
        
        
xmit.startMsg("stage", "i");
3 => xmit.addInt;
spork ~ n_gen(0, 4, "swing", shape_1, len, 124, flute, flute_e, flute_g, flute_p);
spork ~ n_gen(1, 4, "all_d-swing", shape_1, len, 124, _, _e, _g, _p);
spork ~ n_gen(2, 2, "swing", shape_1, len, 62, pluck, pluck_e, pluck_g, pluck_p);
spork ~ n_gen(3, 4, "all_h-swing", shape_1, len, 124, _, _e, _g, _p);
        n_gen(6, 8, "swing", shape_1, len, 248, marimba, marimba_e, marimba_g, marimba_p);

xmit.startMsg("stage", "i");
4 => xmit.addInt;
spork ~ n_gen(0, 4, "swing", shape_1, len, 124, flute, flute_e, flute_g, flute_p);
spork ~ n_gen(1, 4, "all_d-swing", shape_1, len, 124, _, _e, _g, _p);
spork ~ n_gen(2, 2, "swing", shape_1, len, 62, pluck, pluck_e, pluck_g, pluck_p);
spork ~ n_gen(3, 4, "all_h-swing", shape_1, len, 124, _, _e, _g, _p);
spork ~ n_gen(4, 4, "swing", shape_1, len, 124, piano, piano_e, piano_g, piano_p);
spork ~ n_gen(5, 2, "swing", shape_1, len, 62, bass, bass_e, bass_g, bass_p);
        n_gen(6, 8, "swing", shape_1, len, 248, marimba, marimba_e, marimba_g, marimba_p);
        
xmit.startMsg("stage", "i");
5 => xmit.addInt;
spork ~ n_gen(1, 4, "all_d-swing", shape_1, len, 124, _, _e, _g, _p);
spork ~ n_gen(2, 2, "swing", shape_1, len, 62, pluck, pluck_e, pluck_g, pluck_p);
spork ~ n_gen(3, 4, "all_h-swing", shape_1, len, 124, _, _e, _g, _p);
spork ~ n_gen(4, 4, "swing", shape_1, len, 124, piano, piano_e, piano_g, piano_p);
spork ~ n_gen(5, 2, "swing", shape_1, len, 62, bass, bass_e, bass_g, bass_p);
        n_gen(6, 8, "swing", shape_1, len, 248, marimba, marimba_e, marimba_g, marimba_p);
        
xmit.startMsg("stage", "i");
6 => xmit.addInt;
spork ~ n_gen(3, 4, "all_h-swing", shape_1, len, 124, _, _e, _g, _p);
spork ~ n_gen(4, 4, "swing", shape_1, len, 124, piano, piano_e, piano_g, piano_p);
spork ~ n_gen(5, 2, "swing", shape_1, len, 62, bass, bass_e, bass_g, bass_p);
        n_gen(6, 8, "swing", shape_1, len, 248, marimba, marimba_e, marimba_g, marimba_p);
        
xmit.startMsg("stage", "i");
7 => xmit.addInt;
spork ~ n_gen(4, 6, "swing", shape_1, len, 124, piano, piano_e, piano_g, piano_p);
        n_gen(5, 3, "swing", shape_1, len, 62, bass, bass_e, bass_g, bass_p);
        
        
for (0 => int k; k < 30; k+1 => k) {
    xmit.startMsg("vol", "f");
    1.0 - (k / 30.0) => xmit.addFloat;
    (8.0 / 62.0)::second => now;
}
(120.0 / 62.0)::second => now;


xmit.startMsg("vol", "f");
1.0 => xmit.addFloat;
xmit.startMsg("level", "i");
1 => xmit.addInt;
xmit.startMsg("stage", "i");
4 => xmit.addInt;
spork ~ n_gen(0, 1, "pentatonic", shape_1, len, 62, bass, bass_e, bass_g, bass_p);
spork ~ n_gen(1, 2, "all_h", shape_1, len, 124, _, _e, _g, _p);
spork ~ n_gen(2, 1, "pentatonic", shape_1, len, 62, marimba, marimba_e, marimba_g, marimba_p);
spork ~ n_gen(3, 2, "all_d", shape_1, len, 124, _, _e, _g, _p);
spork ~ n_gen(4, 1, "pentatonic-light", shape_1, len, 62, pluck, pluck_e, pluck_g, pluck_p);
spork ~ n_gen(5, 2, "pentatonic-light", shape_1, len, 124, piano, piano_e, piano_g, piano_p);
        n_gen(6, 4, "pentatonic", shape_1, len, 248, flute, flute_e, flute_g, flute_p);

xmit.startMsg("level", "i");
2 => xmit.addInt;
spork ~ n_gen(6, 2, "swing", shape_1, len, 124, flute, flute_e, flute_g, flute_p);
spork ~ n_gen(3, 2, "all_d-swing", shape_1, len, 124, _, _e, _g, _p);
spork ~ n_gen(4, 1, "swing", shape_1, len, 62, pluck, pluck_e, pluck_g, pluck_p);
spork ~ n_gen(1, 2, "all_h-swing", shape_1, len, 124, _, _e, _g, _p);
spork ~ n_gen(5, 2, "swing", shape_1, len, 124, piano, piano_e, piano_g, piano_p);
spork ~ n_gen(0, 1, "swing", shape_1, len, 62, bass, bass_e, bass_g, bass_p);
        n_gen(2, 4, "swing", shape_1, len, 248, marimba, marimba_e, marimba_g, marimba_p);
        
xmit.startMsg("level", "i");
1 => xmit.addInt;
spork ~ n_gen(0, 1, "pentatonic", shape_1, len, 62, bass, bass_e, bass_g, bass_p);
spork ~ n_gen(1, 2, "all_h", shape_1, len, 124, _, _e, _g, _p);
spork ~ n_gen(2, 1, "pentatonic", shape_1, len, 62, marimba, marimba_e, marimba_g, marimba_p);
spork ~ n_gen(3, 2, "all_d", shape_1, len, 124, _, _e, _g, _p);
spork ~ n_gen(4, 1, "pentatonic-light", shape_1, len, 62, pluck, pluck_e, pluck_g, pluck_p);
spork ~ n_gen(5, 2, "pentatonic-light", shape_1, len, 124, piano, piano_e, piano_g, piano_p);
        n_gen(6, 4, "pentatonic", shape_1, len, 248, flute, flute_e, flute_g, flute_p);

xmit.startMsg("level", "i");
2 => xmit.addInt;
spork ~ n_gen(6, 2, "swing", shape_1, len, 124, flute, flute_e, flute_g, flute_p);
spork ~ n_gen(3, 2, "all_d-swing", shape_1, len, 124, _, _e, _g, _p);
spork ~ n_gen(4, 1, "swing", shape_1, len, 62, pluck, pluck_e, pluck_g, pluck_p);
spork ~ n_gen(1, 2, "all_h-swing", shape_1, len, 124, _, _e, _g, _p);
spork ~ n_gen(5, 2, "swing", shape_1, len, 124, piano, piano_e, piano_g, piano_p);
spork ~ n_gen(0, 1, "swing", shape_1, len, 62, bass, bass_e, bass_g, bass_p);
        n_gen(2, 4, "swing", shape_1, len, 248, marimba, marimba_e, marimba_g, marimba_p);


xmit.startMsg("level", "i");
1 => xmit.addInt;
spork ~ n_gen(0, 1, "pentatonic", shape_4, len, 31, bass, bass_e, bass_g, bass_p);
spork ~ n_gen(1, 2, "all_h", shape_4, len, 62, _, _e, _g, _p);
spork ~ n_gen(2, 1, "pentatonic", shape_4, len, 31, marimba, marimba_e, marimba_g, marimba_p);
spork ~ n_gen(3, 2, "all_d", shape_1, len, 62, _, _e, _g, _p);
spork ~ n_gen(4, 1, "pentatonic-light", shape_1, len, 31, pluck, pluck_e, pluck_g, pluck_p);
spork ~ n_gen(5, 2, "pentatonic-light", shape_1, len, 62, piano, piano_e, piano_g, piano_p);
        n_gen(6, 4, "pentatonic", shape_1, len, 124, flute, flute_e, flute_g, flute_p);
        
xmit.startMsg("level", "i");
2 => xmit.addInt;
spork ~ n_gen(0, 4, "pentatonic", shape_1, len, 124, bass, bass_e, bass_g, bass_p);
spork ~ n_gen(1, 8, "all_h", shape_1, len, 248, _, _e, _g, _p);
spork ~ n_gen(2, 4, "pentatonic", shape_1, len, 124, marimba, marimba_e, marimba_g, marimba_p);
spork ~ n_gen(3, 8, "all_d", shape_4, len, 248, _, _e, _g, _p);
spork ~ n_gen(4, 4, "pentatonic-light", shape_4, len, 124, pluck, pluck_e, pluck_g, pluck_p);
spork ~ n_gen(5, 8, "pentatonic-light", shape_4, len, 248, piano, piano_e, piano_g, piano_p);
        n_gen(6, 16, "pentatonic", shape_4, len, 496, flute, flute_e, flute_g, flute_p);


xmit.startMsg("vol", "f");
1.0 => xmit.addFloat;
xmit.startMsg("level", "i");
1 => xmit.addInt;
xmit.startMsg("stage", "i");
4 => xmit.addInt;   
n_gen(3, 4, "all_d", shape_1, len, 496, _, _e, _g, _p);
spork ~ n_gen(3, 4, "all_h", shape_1, len, 496, _, _e, _g, _p);
n_gen(3, 4, "all_d", shape_1, len, 496, _, _e, _g, _p);

0.5::second => now;

xmit.startMsg("stage", "i");
1 => xmit.addInt; 
n_gen(0, 1, "pentatonic", shape_1, len, 62, bass, bass_e, bass_g, bass_p);
// 8710::ms => now;

for (0 => int k; k < 30; k+1 => k) {
    xmit.startMsg("vol", "f");
    1.0 - (k / 30.0) => xmit.addFloat;
    (8.0 / 62.0)::second => now;
}
xmit.startMsg("stage", "i");
0 => xmit.addInt;

xmit.startMsg("bf", "i");
2 => xmit.addInt;
