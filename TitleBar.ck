// construct a visual title bar out of overlapping MAUI_Gauges (hack).
public class TitleBar {
  MAUI_Gauge topGauges[0];
  MAUI_Gauge bottomGauges[0];
  MAUI_Text titleText;

  fun void init(int xOffset, int yOffset, 
                string title, int titleOffset, 
                int numGaugesAcross, int gaugeOffset) {
    // top bar.
    for(0 => int i; i < numGaugesAcross; i++) {
      MAUI_Gauge gauge; 
      gauge.position(xOffset+gaugeOffset*i, yOffset);
      topGauges << gauge;
    }
    // title text.  
    titleText.name(title);
    titleText.position(xOffset+titleOffset, yOffset+14);
    // bottom bar.
    for(0 => int i; i < numGaugesAcross; i++) {
      MAUI_Gauge gauge; 
      gauge.position(xOffset+gaugeOffset*i, yOffset+35);
      bottomGauges << gauge;
    }
  }


  fun void addElementsToView(MAUI_View view) {
    for(0 => int i; i < topGauges.cap(); i++) 
      view.addElement(topGauges[i]);
    view.addElement(titleText);
    for(0 => int i; i < bottomGauges.cap(); i++) 
      view.addElement(bottomGauges[i]);
  } 
}
