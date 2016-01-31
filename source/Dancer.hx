package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class Dancer extends FlxSprite
{
    public function new(X:Float, Y:Float)
    {
        super(X, Y);
        loadGraphic("assets/images/dancer.png", true, 59, 64);
        animation.add("dance", [0, 1, 2, 3, 4, 5], 2, true);
        animation.play("dance");
    }

    public override function update():Void
    {
        super.update();
    }
}
