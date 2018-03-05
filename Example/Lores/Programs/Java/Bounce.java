package bigpix.examples;

import bigpix.*;

public class Bounce extends BigPix.Program {
	final Point MAX_POINT;

	Point ball;
	Offset ballDir;
	Color ballColor;

	public static void main(String... args) {
		BigPix.start(new Bounce());
	}


	protected Bounce() {
		MAX_POINT = getMaxPoint();
	}

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

	//
	// Drawing methods: These methods do not change the model
	//

	private void beginFrame() {
		erase(Color.BLACK);
	}

	private void endFrame() {
		flush();
		sleep(0.05);
	}

	private void drawFrame() {
		setPixel(ball, ballColor);
	}

	//
	// Model methods: These methods do not draw
	//

	private void setupModel() {
		ball = Random.randomPoint(MAX_POINT);
		ballDir = new Offset(Random.coinFlip() ? -1 : 1, Random.coinFlip() ? -1 : 1);
		ballColor = Random.randomColor();
	}

	private void updateModel() {
		Point testBall = ball.add(ballDir);
		if(testBall.x < 0 || testBall.x > MAX_POINT.x) {
			ballDir = new Offset(-ballDir.dx, ballDir.dy);
		}
		if(testBall.y < 0 || testBall.y > MAX_POINT.y) {
			ballDir = new Offset(ballDir.dx, -ballDir.dy);
		}

		ball = ball.add(ballDir);
	}
}
