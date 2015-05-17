public interface mover{
	public void move();
}

public class buggy implements mover {
	private double speed;
	private int xPos;
	public buggy(double s){
		xpos = 400;
		speed = s;
	}
	public void move(){
		xpos-=speed;
	}
	public void show(){
		fill(255, 0, 0);
		ellipse(xpos, height-(height-30), 20, 20);
	}
}
fill(0, 0, 255);
ellipse(200, 200, 200, 200);