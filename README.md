# i <| geometry
## Stanford Music 220b final project, Vince Ranganathan (Winter 2018)

To run the piece, first open up the application (final_graphics.app), and then in miniAudicle add the "i <| geometry.ck" shred to the virtual machine. The piece begins and ends on a blackout screen. You will need MiniAudicle installed in order to be able to run the ChucK file.

Updated 12/23/2018

----------------------------------------------------------------------------------------------------------------------

This piece is based on a partially randomized drum machine, that operates by generating a random path down a network of nodes, and altering parameters of the music while traversing this path. The components of the piece are described in more detail below:

**Networks:** Each network has nine layers, where the first and last layer have exactly one node, and the rest of the layers have at least one. Moving from layer k to k+1, the number of nodes can either increase of decrease by one. An example of a 'diamond' shaped network is:

![alt text](https://github.com/vinceranga/i-geometry/blob/master/pics/diamond.png "diamond"){ width=50% }
 
A path is generated using the following rules: (1) the next node is either the one to the bottom-left or bottom-right of the current node. If only one of these is available, that is the next node. (2) If in the center (node = 0), pick left or right both with probability 1/2; if left of center (node < 0), pick left with probabilty 2/3 and right with 1/3; if right of center (node > 0), pick left with probability 1/3 and right with 2/3. This allows the path to explore the edges of the shape more frequently.

The node number is the location of the node along a horizontal axis; that is, the central nodes have number 0, and moving left decreases the number by 1 while moving right increases it by 1. In the diamond pattern, the node number can vary from -4 to 4, while in the zipper pattern, it is restricted to -1 to 1.

**Sound:** There are seven instruments in the piece: bass guitar, a set of cymbals/hats, a marimba, a piano, a 'pluck' synthesizer, a drum set, and a flute. The pitched instruments play either the A minor or E minor pentatonic scale, with the central node representing the A or E, and lower or higher nodes representing lower or higher notes in the scale. The percussive instruments are symmetrical, i.e. nodes -k and k play the same sounds, but are panned according to their position in the graph.

Here's some ChucK code that generates sounds according to a pattern and transmits them out for Processing to catch:
```c
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
```

**Piece structure:** The piece has three sections. The first introduces the concepts, bringing in instruments gradually and experimenting with the different types of sounds created by different network shapes. The second (after the first fade) switches the order of the instruments (which instrument corresponds to which network) and moves into the swing rhythm. The third experiments with tempo and rapidly alternates between even and swing rhythms before fading out.

**Visuals:** Programmed using Processing. The current node that is selected in the path is lit up as the corresponding sound is played. Previous nodes in the path are dimmed as necessary. The size of the nodes is proportional to the volume of the instrument. A square, light-blue node indicates a percussive instrument, while a purple, circle or triangle node represents a pitched instrument. Circles represent even rhythm (1 2, 1 2) while triangles represent swing rhythm (1 _ 3, 1 _ 3).

![alt text](https://github.com/vinceranga/i-geometry/blob/master/pics/circles.png "circles")

![alt text](https://github.com/vinceranga/i-geometry/blob/master/pics/triangles.png "triangles")

Huge thanks to Ge Wang and Orchi Das for their incredible instruction, and the whole 220b class for such high quality feedback.

Enjoy the experience!

-Vince
