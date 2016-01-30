package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;

/**
 * A FlxState which can be used when the game is over
 */
class GameOverState extends FlxState
{
    private var playerWon:Bool;

    public function new(won:Bool)
    {
        playerWon = won;
        super();
    }

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
        var title = new FlxText(0, 60, 640, playerWon ? "You Win!" : "Game Over!", 22);
		title.alignment = "center";
		//title.screenCenter(true, false);
		add(title);

		super.create();
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();
	}	
}
