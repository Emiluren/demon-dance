package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class Arrow extends FlxSprite
{
    public function new(X:Float, Y:Float, Speed:Float)
    {
        super(X, Y);

        makeGraphic(40, 40, FlxColor.WHITE);
        velocity.x = Speed;
    }

    public override function update():Void
    {
        super.update();
    }

    public function hit():Void
    {
        makeGraphic(40, 40, FlxColor.GREEN);
    }

    public override function destroy():Void
    {
        super.destroy();
    }
}
