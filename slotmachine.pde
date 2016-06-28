/**
 * Slotmachine_js:
 * a funny application to select an item randomly.
 * <br>
 * @author y-takata, 2013/Oct/15
 */

String[] allItems = {
  "1班",
  "2班",
  "3班",
  "4班",
  "5班",
  "6班",
  "7班",
};

final float LINE_HEIGHT = 68;
final int ROLLING  = 0;
final int STOPPING = 1;
final int STOPPED  = 2;

Items items;

float y = 0.0;
float vy = 0.2;
int phase = ROLLING;

void setup() {
  size(400, 160);
  items = new Items();
  items.shuffle();
  stroke(255);
  noFill();
  textSize(64);
  textAlign(CENTER, BOTTOM);
}

int index(float y, int i) {
  return (int(y) + i) % items.size();
}

void draw() {
  float dy = y - int(y);
  background(0);
  for (int i = 0; i < 5; i++) {
    text(items.get(index(y, i)),
         width/2, height + (dy - i) * LINE_HEIGHT);
  }

  if (phase == STOPPING) {
    if (vy >= 0.002) {
      vy -= 0.001;  // slowing down
    } else {
      phase = STOPPED;
      vy = 0.2;     // re-initialize
    }
  }
  if (phase != STOPPED) {
    y += vy;
  }
  if (phase == STOPPED) {
    rect(20, height + (dy - 2) * LINE_HEIGHT,
         width - 40, LINE_HEIGHT);
  }
}

void mousePressed() {
  if (mouseX < width/4 && mouseY < height/2) {
    items.reset();
    phase = ROLLING;
    vy = 0.2;
  }
  else if (phase == ROLLING) {
    phase = STOPPING;
  }
  else if (phase == STOPPED) {
    items.remove(index(y, 1));
    phase = ROLLING;
    if (items.size() <= 0) noLoop(); // no items remain
  }
}

/**
 * The set of rolling items
 */
class Items {
  String[] items;
  int numItem;

  Items() {
    reset();
  }

  public String get(int i) {
    return items[i];
  }
  public int size() {
    return numItem;
  }

  private void swap(int i, int j) {
    String tmp = items[i];
    items[i] = items[j];
    items[j] = tmp;
  }

  public void shuffle() {
    for (int i = 0; i < numItem; i++) {
      this.swap(i, int(random(numItem)));
    }
  }

  public void reset() {
    items = new String[allItems.length];
    numItem = allItems.length;
    for (int i = 0; i < numItem; i++) {
      items[i] = allItems[i];
    }
    this.shuffle();
  }

  public void remove(int j) {
    //  println(items[j]);
    numItem--;
    for (int i = j; i < numItem; i++) {
      items[i] = items[i + 1];
    }
  }
}

