package ;

import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.util.FlxAngle;

/**
 * ...
 * @author Goldy
 */
class Pacman extends FlxSprite
{
	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		
		loadGraphic(AssetPaths.pacmanO__png, true, 50, 50);
		
		setFacingFlip(FlxObject.LEFT, false, false);
		setFacingFlip(FlxObject.RIGHT, true, false);
		setFacingFlip(FlxObject.UP, false, false);
		setFacingFlip(FlxObject.DOWN, false, false);
		
		setSize(37, 37); //39,39 en realidad
		offset.set(4, 6);
		
	}
	
	override public function update():Void
    {
        super.update();
		
		movement();
	}
	
	private function movement():Void
	{
		var _up:Bool = false;
		var _down:Bool = false;
		var _left:Bool = false;
		var _right:Bool = false;
		
		_up = FlxG.keys.anyPressed(["UP", "W"]);
		_down = FlxG.keys.anyPressed(["DOWN", "S"]);
		_left = FlxG.keys.anyPressed(["LEFT", "A"]);
		_right = FlxG.keys.anyPressed(["RIGHT", "D"]);
		 
		var sum:Int = 0;
		if (_up) sum++;
		if (_down) sum++;
		if (_left) sum++;
		if (_right) sum++;
		
		if (sum == 1) {
			var mA:Float = 0;
			if (_up)
			{
				mA = -90;
				facing = FlxObject.UP;
				angle = 90;
			}
			else if (_down)
			{
				mA = 90;
				facing = FlxObject.DOWN;
				angle = -90;
			}
			else if (_left) {
				mA = 180;
				facing = FlxObject.LEFT;
				angle = 0;
			}
			else if (_right) {
				mA = 0;
				facing = FlxObject.RIGHT;
				angle = 0;
			}
				
			FlxAngle.rotatePoint(200, 0, 0, 0, mA, velocity);
		}
		
		
	}

}