%   MUMT 307 (Music & Audio Computing II)
%   Final Project.  Modal Synthesis analysis.
%   Max Henry #260133798

%   This script is primarily a sketchbook for different scaling curves I
%   was experimenting with.  Each curve depends on one or more input values
%   (e.g. "velocity" or "midiin").  The curve in each case is plotted.

clear;

%   overtoneCurve: Scaling the relative filter gains based on input
%   velocity.  A high velocity results in a flatter frequency scaling.
%   Lower velocity attenuates higher-frequency filters by this curve.

velocity = 1;
numFilts = 38;

p = (0:numFilts - 1);

pcurve = (velocity/127).^(p / numFilts * 5);

figure();
subplot(2, 1, 1);
plot(p, pcurve);
xlim([0 numFilts]);
xlabel('Filter number (i)');
ylim([0 1.02]);
ylabel('Gain (normalized)');
title(['overtoneCurve[i] VELOCITY = ' num2str(velocity)]);

%   Adding a contribution from the transposition ratio (stretch): the more
%   stretched the desired output pitch is from the input sample pitch, the
%   more muted the upper harmonics become.

notein = 26;
noteout = 52;
if (notein/noteout < 1)
   stretch = notein/noteout;
else
   stretch = 1;
end

vpcurve = stretch*(velocity/127).^(p / numFilts * 5);

subplot(2, 1, 2);
plot(p, vpcurve);
xlim([0 numFilts]);
xlabel('Filter number (i)');
ylim([0 1.02]);
ylabel('Gain (normalized)');
title(['overtoneCurve[i] modulated by stretch, STRETCH FACTOR = ' num2str(stretch)]);

%%

%   Special curve for turning on/off partials?  Option 1.

clear;

numfilts = 38;

noteout = 70;

dif = noteout/127;

filternum = (0:numfilts - 1);

scaling = (filternum + dif)./(filternum) - 1.8*dif;

plot(filternum, scaling);

xlim([0 numfilts]);
ylim([0 1]);
xlabel('Filter number (i)');
ylim([0 1.02]);
ylabel('Gain (normalized)');
title(['Muting partials by pitch Option 1 -- MIDI NOTE = ' num2str(noteout)]);

%%

%   Sigmoid curve for turning on/off partials?  Option 2.

clear;

noteout = 50;
numfilts = 38;
filternum = (1:numfilts);

coefficient = numfilts * (1 - noteout/127);

scaling = 1./(1 + exp(5*(filternum - (coefficient + 1))));

plot(filternum, scaling);
xlim([0 numfilts]);
ylim([0 1]);
xlabel('Filter number (i)');
ylim([0 1.02]);
ylabel('Gain (normalized)');
title(['Muting partials by pitch Option 2 -- MIDI NOTE = ' num2str(noteout)]);

%%

%   Scaling the env sustain value by the "stretch factor," i.e. how
%   different is the note-out value from the input sample note.

defaultSus = 10;

notein = 26;
noteout = (1:127);

stretch = defaultSus*(notein./noteout).^1.5;

plot(stretch);
xlabel('Midi pitch out');
ylabel('Length of sustain (s)');
ylim([0 50]);
title(['Sustain env stretch or squish by pitch SAMPLE MIDI PITCH = ' num2str(notein)]);
