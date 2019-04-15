# modalengine
Modal Analysis and Synthesis Engine

This code will analyze a .wav file of a single recorded note for its modal resonant structure, and attempt to generate a synthesis engine from that single note.

It is in two parts, a MATLAB script and a C++ program.  The MATLAB script does the analysis, and the C++ code takes care of the resynthesis.  

Note:: the synthesis toolkit (stk) is required to compile the C++ code.
https://ccrma.stanford.edu/software/stk/

(-1) Download and expand modalengine.zip — it shouldn’t matter where this is on your computer, so long as all of the contents stay within this subdirectory.

(0) If you haven't already, compile the C++ code.  You will need STK, and you will need to specify both the include and library paths.  Here's how this looks on my machine (you will have to change the paths as necessary):

g++ -I/Users/maxsolomonhenry/Documents/cprojects/stk-4.6.0/include/ -L/Users/maxsolomonhenry/Documents/cprojects/stk-4.6.0/src/ -D__MACOSX_CORE__ 307finalWAV.cpp -lstk -lpthread -framework CoreAudio -framework CoreMIDI -framework CoreFoundation

(1) Run the MATLAB code, taking care to specify which .wav file you want analyzed in the audioread function (line 18).  Example sounds can be found in the "examples" directory.  This will output a csv file to be read by the C++ component.

(2) Run the compiled code with the following specifications:

./a.out \<notein\> \<noteout\> \<velocity\> \<duration\>

Where \<notein\> is a value from 0-127 indicating the midi pitch of the analyzed sample,\
\<noteout\> is a value from 0-127 specifying the desired output pitch (also in midi),\
\<velocity\> is a value from 0-127 indicating note output velocity (higher = louder and more overtones), and\
\<duration\> is a value from 0.1 - 6 indicating the desired note duration time in seconds.

***note, please don't use the \< \> brackets when passing your parameters!

(3) Enjoy.

(4) Repeat.  I encourage you to experiment with a variety of input sounds.  Some work better than others, but they always sound pretty cool.

Thank you for your interest.

// Max Henry\
// McGill University\
// Montreal, Qc\
// April 15, 2019.
