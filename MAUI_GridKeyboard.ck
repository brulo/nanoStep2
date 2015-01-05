public class MAUI_GridKeyboard {
  MAUI_Button buttons[64];
  
  fun void init(MAUI_View view) {
    for(0 => int x; x < 8; x++) {
      for(0 => int y; y < 8; y++) {
        x + y*8 => int buttonIndex;
        buttons[buttonIndex].position(x*50, y*50);
        buttons[buttonIndex].pushType();
        buttons[buttonIndex].name(Std.itoa(x+(7-y)*8));
        spork ~ buttonLoop(buttons[buttonIndex], x+(7-y)*8);
        view.addElement(buttons[buttonIndex]);
      }
    } 
  }
  
  fun void buttonLoop(MAUI_Button button, int noteValue) {
    while(button => now) {
      if(button.state()) { 
        <<<noteValue, "">>>; 
      }
      else {
      }
    }
  }

}
