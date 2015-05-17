
ArrayList<Mover> movers = new ArrayList<Mover>();
ArrayList<Bullet> bullets = new ArrayList<Bullet>();
ArrayList<Ammobox> ammos = new ArrayList<Ammobox>();
Player p;
public final int ADD_BUGGY = 2000;
public final int ADD_FLYER = 3000;
public final int ADD_AMMO = 6000;
public int bugTimer;
public int flyTimer;
public int jumpTimer;
public int shotTimer;
public int ammoboxTimer;
public int score;
public int ammo;
public boolean gameOver;

public void setup(){
  p = new Player();
  size(568, 320);
  ammo = 20;
  score = 0;
  jumpTimer = -1;
  shotTimer = -1;
  gameOver = false;
  ammoboxTimer = millis();
  bugTimer = millis();
  flyTimer = millis();
  movers.add(new Buggy(3));
  noStroke();
}
public void draw(){
  background(128, 204, 255);
  if(gameOver == false){
    fill(0, 36, 107);
    textSize(32);
    text("Score: "+score, 20, 40);
    text("Bullets: "+ammo, width-180, 40);
    if(millis()-bugTimer>ADD_BUGGY){
      movers.add(new Buggy(Math.random()*2+2));
      bugTimer = millis();
    }
    if(millis()-ammoboxTimer>ADD_AMMO){
      ammos.add(new Ammobox(2));
      ammoboxTimer = millis();
    }
    if(millis()-flyTimer>ADD_FLYER){
      movers.add(new FlyingBuggy(Math.random()*2+2, (int)((Math.random()+10)*3)+30));
      flyTimer = millis();
    }
    p.show();
    p.checkHit();
    checkHits();
    checkBounds();
    for(Bullet b : bullets){
      b.move();
      b.show();
    }
    for(Mover bug : movers){
      bug.move();
      bug.show();
    }
    for(Ammobox am : ammos){
      am.move();
      am.show();
    }
    fill(153, 102, 51);
    rect(0, height-20, width, 20);
    if(keyPressed && key==' ' && jumpTimer<0 && p.getY()<35){
      jumpTimer = millis();
    }
    if(jumpTimer>0){
      if(keyPressed && key == ' ' && millis()-jumpTimer<1000){
        p.upJump(abs(((millis()-jumpTimer)-1000))/200.0);
      } else if(p.getY()>30){
        p.downJump(abs((millis()-jumpTimer)-1000)/200.0);
      } else {
        jumpTimer = -1;
      }
    }
    if(keyPressed && keyCode == UP && shotTimer<0){
      shotTimer = millis();
    }
    if(shotTimer>0){
      if(keyPressed && keyCode == UP && millis()-shotTimer<10 && ammo>0){
        bullets.add(new Bullet(p.getX(), p.getY()));
        ammo--;
      } else if(millis()-shotTimer>300) {
        shotTimer = -1;
      }
    }
  } else {
    fill(153, 0, 0);
    textAlign(CENTER);
    textSize(64);
    text("Game Over...", width/2, height/2);
    textSize(32);
    text("Your sore: "+score, width/2, height/2);
  }
}

public void checkHits(){
  for(int i = bullets.size()-1; i >= 0; i--){
    Bullet b = bullets.get(i);
    for(int j = movers.size()-1; j>=0; j--){
      Mover m = movers.get(j);
      if(b.getX()<m.getX()+10 && b.getX()>m.getX()-10 && b.getY()<m.getY()+10 && b.getY()>m.getY()-10){
        bullets.remove(i);
        movers.remove(j);
        score++;
      }
    }
  }
}
public void checkBounds(){
  for(int i = bullets.size()-1; i >= 0; i--){
    Bullet b = bullets.get(i);
    if(b.getX()>width){
      bullets.remove(i);
    }
  }
  for(int j = movers.size()-1; j>=0; j--){
    Mover m = movers.get(j);
    if(m.getX()<0){
        movers.remove(j);
    }
  }
}
public interface Mover{
  public void move();
  public void show();
  public int getX();
  public int getY();
}

public class Buggy implements Mover {
  private double speed;
  private int xpos;
  public Buggy(double s){
    xpos = 1400;
    speed = s;
  }
  public int getX(){
    return xpos;
  }
  public int getY(){
    return 20;
  }
  public void move(){
    xpos-=speed;
  }
  public void show(){
    noStroke();
    fill(255, 0, 0);
    ellipse(xpos, height-30, 20, 20);
  }
}

public class FlyingBuggy implements Mover{
  private double speed;
  private int xpos;
  private int ypos;
  public FlyingBuggy(double s, int y){
    ypos = y;
    xpos = 1400;
    speed = s;
  }
  public int getX(){
    return xpos;
  }
  public int getY(){
    return ypos;
  }
  public void move(){
    xpos-=speed;
  }
  public void show(){
    fill(255, 0, 0);
    ellipse(xpos, height-ypos, 20, 20);
  }
}

public class Ammobox implements Mover {
  private double speed;
  private int xpos;
  public Ammobox(double s){
    xpos = 1400;
    speed = s;
  }
  public int getX(){
    return xpos;
  }
  public int getY(){
    return 30;
  }
  public void move(){
    xpos-=speed;
  }
  public void show(){
    noStroke();
    fill(0, 0, 153);
    rect(xpos, height-100, 20, 30, 10, 10, 3, 3);
  }
}
public class Player{
  private int xpos;
  private int ypos;
  private int size;
  private int flashTimer;
  private boolean hit;
  public Player(){
    flashTimer = 0;
    hit = false;
    size = 20;
    xpos = 30;
    ypos = 30;
  }
  public int getSize(){
    return size;
  }
  public int getX(){
    return xpos;
  }
  public int getY(){
    return ypos;
  }
  public void upJump(double amt){
    ypos+=amt;
  }
  public void downJump(double amt){
    ypos-=amt;
  }
  public void show(){
    stroke(153, 230, 255);
    if(hit==true){
      flashTimer=millis();
    } else{
      fill(0, 51, 153);
    }
    if(flashTimer!=0){
        if(millis()-flashTimer<1000){
          fill(255, 0, 0);
        }else if(millis()-flashTimer>1000){
          flashTimer = 0;
          hit = false;
        }
      }
    ellipse(xpos, height-ypos, size, size);
  }
  public boolean checkHit(){
    for(Mover m : movers){
      if(m.getX()<xpos+10 && m.getX()>xpos-10 && m.getY()<ypos+20 && m.getY()>ypos-20){
        hit = true;
        if(ammo == 0){
          gameOver = true;
        }
        return hit;
      }
    }
    for(Ammobox a : ammos){
      if(a.getX()<xpos+15 && a.getX()>xpos-15 && a.getY()<ypos+20 && a.getY()>ypos-20){
        ammo++;
      }
    }
    hit = false;
    return hit;
  }
}

public class Bullet {
  private int xpos;
  private int ypos;
  private int speed;
  public Bullet(int x, int y){
    xpos = x;
    ypos = y;
    speed = 3;
  }
  public int getX(){
    return xpos;
  }
  public int getY(){
    return ypos;
  }
  public void show(){
    fill(0, 0, 255);
    rect(xpos, height - ypos, 20, 5, 3);
  }
  public void move(){
    xpos+=speed;
  } 
}
