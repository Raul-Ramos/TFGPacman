package ;

import flixel.FlxSprite;
import flixel.util.FlxColor;

using flixel.util.FlxSpriteUtil;

/**
 * ...
 * @author Goldy
 */
class Dot extends FlxSprite
{

	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		
		makeGraphic(9, 9, FlxColor.TRANSPARENT, true);
		drawRect(0, 0, 9, 9, 0xffFFB897);
		//drawCircle(0, 0, 5, 0xffFFB897);
	}
	
}