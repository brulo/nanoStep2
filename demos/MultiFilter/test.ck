SawOsc saw => MultiFilter mfilt => Gain gain => dac;
MultiFilterGui mFiltGui;

gain.gain(0.5);
MAUI_View view;
saw.freq(440);

<<<"MultiFilter test", "">>>;
<<<"initializing MultiFilter", "">>>;
mfilt.init();
mFiltGui.init(mfilt, view, 0, 0);

<<<"initializing GUI", "">>>;
view.display();

/* <<<"filter test", "">>>; */
/* <<<"cutoff frequency", "">>>; */
/* for(-0.25 => float i; i <= 1.25; 0.01 +=> i) { */
/*   mfilt.freq(i); */
/*   15::ms => now; */  
/* } */
/* <<<"Q", "">>>; */
/* for(-0.25 => float i; i <= 1.25; 0.25 +=> i) { */
/*   mfilt.Q(i); */ 
/*   <<<i, "">>>; */
/*   for(-0.25 => float i; i <= 1.25; 0.01 +=> i) { */
/*     mfilt.freq(i); */
/*     25::ms => now; */  
/*   } */
/* } */

/* SinOsc osc => blackhole; */
/* osc.freq(8); */
/* osc.gain(0.5); */
/* mfilt.addFreqMod(osc); */
<<<"added sin mod to cutoff freq">>>;

<<<"hand test the GUI now", "">>>;

10::second => now;
