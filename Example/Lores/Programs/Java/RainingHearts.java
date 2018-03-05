package bigpix.examples;

import arciem.MathUtils;
import bigpix.*;

import java.util.Arrays;

public class RainingHearts extends BigPix.Program {
	
	final Point MAX_POINT = getMaxPoint();
	
	final boolean T = true;
	final boolean F  = false;
	
	final int NUM_HEARTS = 50;
	
	boolean[][][] hearts;
	
	float[] heartX, heartY;
	float[] heartDirX, heartDirY;
	
	Color[] heartColor;

	public static void main(String... args) {
		BigPix.start(new RainingHearts());
	}
	boolean[][] heartShape0 = new boolean[][] {
		{ F,T,F,T,F },
		{ T,T,T,T,T },
		{ F,T,T,T,F },
		{ F,F,T,F,F }
	};
	
	boolean[][] heartShape1 = new boolean[][] {
		{ F,T,T,F,F,F,T,T,F },
		{ T,T,T,T,F,T,T,T,T },
		{ T,T,T,T,T,T,T,T,T },
		{ F,T,T,T,T,T,T,T,F },
		{ F,F,T,T,T,T,T,F,F },
		{ F,F,F,T,T,T,F,F,F },
		{ F,F,F,F,T,F,F,F,F },
	};
	
	boolean[][] heartShape2 = new boolean[][] {
		{ F,F,T,T,T,F,F,F,T,T,T,F,F },
		{ F,T,T,T,T,T,F,T,T,T,T,T,F },
		{ T,T,T,T,T,T,T,T,T,T,T,T,T },
		{ T,T,T,T,T,T,T,T,T,T,T,T,T },
		{ T,T,T,T,T,T,T,T,T,T,T,T,T },
		{ F,T,T,T,T,T,T,T,T,T,T,T,F },
		{ F,F,T,T,T,T,T,T,T,T,T,F,F },
		{ F,F,F,T,T,T,T,T,T,T,F,F,F },
		{ F,F,F,F,T,T,T,T,T,F,F,F,F },
		{ F,F,F,F,F,T,T,T,F,F,F,F,F },
		{ F,F,F,F,F,F,T,F,F,F,F,F,F }
	};
	
	boolean[][] heartShape3 = new boolean[][] {
		{ F,F,F,T,T,T,T,F,F,F,T,T,T,T,F,F,F },
		{ F,F,T,T,T,T,T,T,F,T,T,T,T,T,T,F,F },
		{ F,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,F },
		{ T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T },
		{ T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T },
		{ T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T },
		{ T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T },
		{ F,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,F },
		{ F,F,T,T,T,T,T,T,T,T,T,T,T,T,T,F,F },
		{ F,F,F,T,T,T,T,T,T,T,T,T,T,T,F,F,F },
		{ F,F,F,F,T,T,T,T,T,T,T,T,T,F,F,F,F },
		{ F,F,F,F,F,T,T,T,T,T,T,T,F,F,F,F,F },
		{ F,F,F,F,F,F,T,T,T,T,T,F,F,F,F,F,F },
		{ F,F,F,F,F,F,F,T,T,T,F,F,F,F,F,F,F },
		{ F,F,F,F,F,F,F,F,T,F,F,F,F,F,F,F,F }
	};

	
	boolean[][][] allShapes = new boolean[][][] {
			heartShape0,
			heartShape1,
			heartShape2,
			heartShape3
	};
	
	@Override
	public void run() {
		setupModel();

		//noinspection InfiniteLoopStatement
		while(true) {
			beginFrame();
			drawFrame();
			endFrame();

			updateModel();
		}
	}
	// Drawing methods: These methods do not change the model
	private void beginFrame() {
		erase(Color.BLACK);
	}

	private void endFrame() {
		flush();
		sleep(0.05);
	}

	private void drawFrame() {
		for(int i = 0; i < NUM_HEARTS; i++){
			setPenColor(heartColor[i]);
			drawShape(hearts[i], Math.round(heartX[i]),Math.round(heartY[i]));
		}
	}

	public void drawShape(boolean[][] shape, int xLoc, int yLoc) {
		Size screenSize = getDimensions();
		for(int y = 0; y < shape.length; y++) {
			for(int x = 0; x < shape[y].length; x++) {
				if(shape[y][x]) {
					int px = (x + xLoc) % screenSize.width;
					if(px < 0) px += screenSize.width;
					int py = (y + yLoc) % screenSize.height;
					if(py < 0) py += screenSize.height;
					setPixel(px, py);
				}
			}
		}
	}
	
	public int shapeHeight(boolean[][] shape) {
		return shape.length;
	}
	
	public int shapeWidth(boolean[][] shape) {
		return shape[0].length;
	}
	
	// Model methods: These methods do not draw
	private void setupModel() {
		
		// Allocate the arrays that will store each attribute of the moving hearts
		hearts = new boolean[NUM_HEARTS][][];
		
		heartX = new float[NUM_HEARTS];
		heartY = new float[NUM_HEARTS];
		
		heartDirX = new float[NUM_HEARTS];
		heartDirY = new float[NUM_HEARTS];
		
		heartColor = new Color[NUM_HEARTS];
		
		// create a random list of shape indexes
		int[] shapesi = new int[NUM_HEARTS];
		for(int i = 0; i < NUM_HEARTS; i++) {
			shapesi[i] = Random.randomInt(0, allShapes.length - 1);
		}
		
		// sort the random list so all the smaller indexes come first:
		// this is so smaller hearts will be drawn first and thus appear
		// "in back of" the larger hearts.
		Arrays.sort(shapesi);
		
		for(int i = 0; i < NUM_HEARTS; i++) {
			int shapei = shapesi[i];
			
			hearts[i] = allShapes[shapei];

			heartX[i] = Random.randomInt(0, MAX_POINT.x);
			
			final float minSpeed = 2.5f;
			final float maxSpeed = 7.5f;
			heartDirX[i] = MathUtils.map((float) shapei, 0.0f, allShapes.length - 1.0f, minSpeed, maxSpeed);
			heartDirX[i] += Random.randomFloat(0.0f, 2.0f);
			heartY[i] = Random.randomInt(0, MAX_POINT.y);
			heartDirY[i] = heartDirX[i];
			float hue;
			float sat = Random.randomFloat(0.8f, 1.0f);
			final float minBri = 0.5f;
			final float maxBri = 1.0f;
			float bri = MathUtils.map((float) shapei, 0.0f, allShapes.length - 1.0f, minBri, maxBri);
			
			for(int j = 0; j < NUM_HEARTS; j++) {	
					float colorPicker = Random.randomFloat(0.0f, 1.0f);
					if (colorPicker < 0.48f){ // if it's not this...
						// shade of purple-red heart
						hue = Random.randomFloat(290.0f / 360.0f, 310.0f / 360.0f);
					} else if(colorPicker < 0.96f){ // then this is checked, and if not this
						// shade of blue heart
						hue = Random.randomFloat(0.56f, 0.58f);
					} else { // then this... 4% chance of hitting "else" clause
						// pure red heart
						hue = 0.0f;
					}
				heartColor[i] = new Color(Color.HSBtoRGB(hue, sat, bri));
			}
		}
	}
	
	private void updateModel() {
		
		for(int i = 0; i < NUM_HEARTS; i++) {
			heartX[i] += heartDirX[i];
			heartY[i] += heartDirY[i];
		}
	}
	
	public Size getPixelSize() {
		return new Size (2, 2);
	}
	
	public Size getDimensions() {
		return new Size(350, 350);
	}
}
