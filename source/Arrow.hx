package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;

/*@:enum
abstract Direction(Float) {
    var Up = 0;
    var Right = 90;
    var Down = 180;
    var Left = 270;
}*/

enum Direction { Up; Right; Down; Left; }

enum ArrowState { New; Hit; Missed; }

class Arrow extends FlxSprite
{
    private var direction:Direction;
    private var state:ArrowState = New;

    public function new(X:Float, Y:Float, Speed:Float)
    {
        super(X, Y);
        var randDir = Std.random(4);
        direction = switch(randDir) {
            case 0: Up;
            case 1: Right;
            case 2: Down;
            default: Left;
        }

        loadGraphic("assets/images/arrow_grey.png");
        angle = randDir*90;
        velocity.x = Speed;
    }

    public override function update():Void
    {
        super.update();
    }

    public function checkHit():Int
    {
        if (FlxG.keys.anyJustPressed(["UP", "RIGHT", "DOWN", "LEFT"])) {
            var oldState = state;
            hit(keyToDirection());
            var newState = state;

            if (oldState == New) {
                if (newState == Hit) {
                    return 1;
                }
                return -1;
            }
        }
        return 0;
    }

    private function keyToDirection():Direction
    {
        if (FlxG.keys.justPressed.UP)
            return Up;
        else if (FlxG.keys.justPressed.RIGHT)
            return Right;
        else if (FlxG.keys.justPressed.DOWN)
            return Down;
        else
            return Left;
    }

    private function hit(dir:Direction):Void
    {
        if (state == New) {
            if (dir == direction) {
                loadGraphic("assets/images/arrow_green.png");
                state = Hit;
            }
            else {
                miss();
            }
        }
    }

    public function miss():Void
    {
        loadGraphic("assets/images/arrow_missed.png");
        state = Missed;
    }

    public function getDirection():Direction
    {
        return direction;
    }

    public function isNew():Bool
    {
        return state == New;
    }

    public override function destroy():Void
    {
        super.destroy();
    }
}
