package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.group.FlxTypedGroup;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import flixel.ui.FlxBar;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
    private var arrows:FlxTypedGroup<Arrow>;
    private var arrowSpawnHeight = FlxG.height * 0.7;
    private var touchingArrow:Arrow = null;
    private var lastArrow:Arrow = null;

    private var arrowSpeed = -0.15;
    private var arrowScore = 5;
    private var missPenalty = 3.0;
    private var penaltyFactor = 1.5;

    private var spawnInterval = 0.5;
    private var timer:FlxTimer;

    private var line:FlxSprite;
    private var progressBar:FlxBar;

    private var dancer:Dancer;
    private var sparkEmitter:FlxEmitter;
    private var smokeEmitter:FlxEmitter;

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
        var bg = new FlxSprite(0, 0);
        bg.loadGraphic("assets/images/background.png");
        add(bg);

        dancer = new Dancer(300, 220, false);
        add(dancer);

        sparkEmitter = new FlxEmitter(330, 200, 50);
		sparkEmitter.setXSpeed(-50, 50);
		sparkEmitter.setYSpeed(-200, -100);
		add(sparkEmitter);
		
		for (i in 0...(Std.int(sparkEmitter.maxSize / 2))) 
		{
            var sparkColor = 0xEEFFFFAA;
			var particle = new FlxParticle();
			particle.makeGraphic(2, 2, sparkColor);
			particle.visible = false; 
			sparkEmitter.add(particle);

			particle = new FlxParticle();
			particle.makeGraphic(1, 1, sparkColor);
			particle.visible = false;
			sparkEmitter.add(particle);
		}
        sparkEmitter.start(false, 0.5, .1);
        sparkEmitter.on = false;

        smokeEmitter = new FlxEmitter(330, 200, 400);
		smokeEmitter.setXSpeed(-50, 50);
		smokeEmitter.setYSpeed(-200, -100);
        smokeEmitter.setAlpha(1, 1, 0, 0);
        smokeEmitter.setScale(0.2, 0.4, 1, 1.2);
		add(smokeEmitter);
		
		for (i in 0...smokeEmitter.maxSize) 
		{
			var particle = new FlxParticle();
			particle.loadGraphic(AssetPaths.smoke__png);
			particle.visible = false; 
			smokeEmitter.add(particle);
		}
        smokeEmitter.start(false, 0.5, .05);
        smokeEmitter.on = false;

        var bgcolor = 0xFF335566;
        var arrowBG = new FlxSprite(0, arrowSpawnHeight-30);
        arrowBG.makeGraphic(640, 100, bgcolor);
        add(arrowBG);

        arrows = new FlxTypedGroup<Arrow>();
        add(arrows);

        line = new FlxSprite(100, arrowSpawnHeight-20);
        line.makeGraphic(10, 80, 0xFFFF6622);
        add(line);

        progressBar = new FlxBar(0, 30, FlxBar.FILL_LEFT_TO_RIGHT, 640, 40);
        progressBar.currentValue = 10;
        progressBar.setRange(0, 100);
        progressBar.createFilledBar(bgcolor, 0xFFE6AA2F);
        add(progressBar);

        timer = new FlxTimer(2, onTimer, 0);

		super.create();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();
        arrows.update();

        // Remove arrows that go off screen
        for (arrow in arrows) {
            if (arrow.x < 0 && !arrow.isOnScreen()) {
                // maybe this is a memory leak because destroy is not called on arrow
                // I don't know
                arrows.remove(arrow);
            }
        }

        touchingArrow = null;
        FlxG.overlap(line, arrows, onArrowLineCollision);

        // Punish the player for mashing keys
        if (touchingArrow == null && FlxG.keys.anyJustPressed(["UP", "RIGHT", "DOWN", "LEFT"])) {
            updateProgress(-Std.int(missPenalty));
        }

        // Give a penalty if the player doesn't press a key in time
        if (lastArrow != touchingArrow && lastArrow.isNew()) {
            lastArrow.miss();
            updateProgress(-Std.int(missPenalty));
        }
	}	

    /**
     * Function that spawns new arrows at an interval
     */
    private function onTimer(Timer:FlxTimer)
    {
        arrows.add(new Arrow(FlxG.width, arrowSpawnHeight, FlxG.width * arrowSpeed));

        // Make the arrows spawn faster as the player progresses
        var prog = progressBar.currentValue;
        var interval_time = timer.time;
        if (prog < 20) {
            interval_time = 2;
            sparkEmitter.on = false;
            smokeEmitter.on = false;
        }
        else if (prog < 40) {
            interval_time = 1.5;
            sparkEmitter.on = false;
            smokeEmitter.on = true;
            smokeEmitter.frequency = 0.5;
        }
        else if (prog < 60) {
            interval_time = 1;
            sparkEmitter.on = true;
            sparkEmitter.frequency = 0.1;
            smokeEmitter.frequency = 0.3;
        }
        else if (prog < 80) {
            interval_time = 0.7;
            sparkEmitter.frequency = 0.05;
            smokeEmitter.frequency = 0.1;
        }
        else {
            interval_time = 0.5;
            sparkEmitter.frequency = 0.01;
            smokeEmitter.frequency = 0.05;
        }

        if (interval_time < timer.time)
            timer.time = interval_time;
    }

    private function updateProgress(value:Int)
    {
        progressBar.currentValue += value;
        if (value > 0)
            missPenalty = 3;
        else if (value < 0)
            missPenalty *= penaltyFactor;

        // Give the player fewer points later in the game so it doesn't end to fast
        var prog = progressBar.currentValue;
        if (prog < 20)
            arrowScore = 5;
        else if (prog < 40)
            arrowScore = 4;
        else if (prog < 60)
            arrowScore = 3;
        else if (prog < 80)
            arrowScore = 2;
        else
            arrowScore = 1;

        if (prog == 0)
            FlxG.switchState(new GameOverState(false));
        if (prog == 100)
            FlxG.switchState(new GameOverState(true));
    }

    private function onArrowLineCollision(line:FlxSprite, arrow:Arrow)
    {
        touchingArrow = arrow;
        lastArrow = arrow;

        // Reward the player for pressing the right key
        var checkResult = arrow.checkHit();
        if (checkResult == 1) {
            updateProgress(arrowScore);
            dancer.dance();
        }
        else if (checkResult == -1) {
            updateProgress(-Std.int(missPenalty));
        }
    }
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
        arrows = null;
        timer = null;
        line = null;
        touchingArrow = null;
        lastArrow = null;

		super.destroy();
	}
}
