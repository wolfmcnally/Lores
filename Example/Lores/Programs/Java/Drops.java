package bigpix.examples;

import bigpix.*;

public class Drops extends BigPix.Program {

	public static void main(String... args) {
		BigPix.start(new Drops());
	}

	public void run() {
		Point maxPoint = getMaxPoint();
		int x = 0;
		int y = 0;
		
		int x2 = maxPoint.x;
		int y2 = maxPoint.y;
		
		int x3 = 0;
		int y3 = maxPoint.y;
		
		int x4 = maxPoint.x;
		int y4 = 0;

		//noinspection InfiniteLoopStatement
		while(true) {
			if(x <= maxPoint.x / 2) {
				setPenColor(Random.randomColor());
			} else {
				setPenColor(Color.BLACK);
			}

			setPixel(x, y);
			setPixel(x2, y2);
			setPixel(x3, y3);
			setPixel(x4, y4);
				
			x++;
			x2--;
			x3++;
			x4--;
			if (x > maxPoint.x && x2 < 0 && x3 > maxPoint.x && x4 < 0){
				x = 0;
				x2 = maxPoint.x;
				x3 = 0;
				x4 = maxPoint.x;
			}
			
			y++;
			y2--;
			y3--;
			y4++;
			if(y > maxPoint.y && y2 < 0 && y3 < 0 && y4 > maxPoint.y) {
				y = 0;
				y2 = maxPoint.y;
				y3 = maxPoint.y;
				y4 = 0;
			}
			
			
			sleep(0.05);
			flush();
		}
	}
}