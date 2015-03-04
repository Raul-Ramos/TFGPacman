package ;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;

/**
 * ...
 * @author Goldy
 */
class Fantasma extends FlxSpriteGroup
{
	private var base:FlxSprite;
	private var ojos:FlxSprite;

	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		
		base = new FlxSprite();
		ojos = new FlxSprite();
		base.loadGraphic(AssetPaths.fantasma__png, true, 50, 50);
		trace(base.replaceColor(Std.parseInt("0xffff0000"), Std.parseInt("0xff31ffff"),true));
		
		
		
		ojos.loadGraphic(AssetPaths.ojos__png, true, 50, 50);
		
		add(base);
		add(ojos);
	}
	
}