package ;

import flixel.FlxSprite;
import flixel.util.FlxColor;

using flixel.util.FlxSpriteUtil;

/**
 * ...
 * @author Goldy
 */
class PowerPellet extends FlxSprite
{

	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		
		makeGraphic(20, 20, FlxColor.TRANSPARENT, true);
		drawCircle(20 / 2, 20 / 2, 20 / 2, 0xffFFB897);
		trace(this.width);
	}
	
}