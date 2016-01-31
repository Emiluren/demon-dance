package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
        var button = new FlxButton(0, 300, "Play", clickPlay);
        button.scale.set(2,2);
        button.label.setFormat(null,20,0x333333,"center");
        button.label.offset.y = 6;
        button.x = 320 - button.width / 2;
        add(button);
		super.create();
	}

    private function clickPlay():Void
    {
        FlxG.switchState(new PlayState());
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
