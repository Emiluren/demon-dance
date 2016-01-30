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

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
    private var arrows:FlxTypedGroup<Arrow>;
    private var arrowSpeed:Float = -0.1;
    private var spawnInterval:Float = 0.5;
    private var timer:FlxTimer;
    private var line:FlxSprite;
    private var arrowSpawnHeight:Float = FlxG.height * 0.7;
    private var touchingArrow:Arrow = null;
    private var lastArrow:Arrow = null;

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
        arrows = new FlxTypedGroup<Arrow>();
        add(arrows);

        line = new FlxSprite(100, arrowSpawnHeight-20);
        line.makeGraphic(10, 80, FlxColor.RED);
        add(line);

        timer = new FlxTimer(2, onTimer, 0);
        onTimer(timer);

		super.create();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();
        arrows.update();

        for (arrow in arrows) {
            if (arrow.x < 0 && !arrow.isOnScreen()) {
                // maybe this is a memory leak because destroy is not called on arrow
                // I don't know
                arrows.remove(arrow);
            }
        }

        touchingArrow = null;
        FlxG.overlap(line, arrows, onArrowLineCollision);
	}	


    /**
     * Function that spawns new arrows at an interval
     */
    private function onTimer(Timer:FlxTimer)
    {
        arrows.add(new Arrow(FlxG.width, arrowSpawnHeight,FlxG.width * arrowSpeed));
    }

    private function onArrowLineCollision(L:FlxSprite, A:Arrow)
    {
        touchingArrow = A;
        lastArrow = A;
        if (FlxG.keys.justPressed.UP)
            A.hit(Up);
        else if (FlxG.keys.justPressed.RIGHT)
            A.hit(Right);
        else if (FlxG.keys.justPressed.DOWN)
            A.hit(Down);
        else if (FlxG.keys.justPressed.LEFT)
            A.hit(Left);
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
