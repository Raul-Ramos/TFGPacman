package ;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;

import Modulo.TipoIA;

/**
 * ...
 * @author Goldy
 */
class Fantasma extends FlxSpriteGroup
{
	private var base:FlxSprite;
	private var ojos:FlxSprite;
	private var ia:Modulo;

	public function new(X:Float = 0, Y:Float = 0, moduloIa:Modulo.Modulo, colorF:String = null) 
	{
		super(X, Y);
		
		this.ia = moduloIa;
		
		base = new FlxSprite();
		ojos = new FlxSprite();
		base.loadGraphic(AssetPaths.fantasma__png, true, 50, 50, true);
		if (colorF != null && colorF.toLowerCase() != "0xffff0000") {
			trace(base.pixels.getPixel32(23,23));
			base.replaceColor(Std.parseInt("0xffff0000"), Std.parseInt(colorF), true);
		}
		
		ojos.loadGraphic(AssetPaths.ojos__png, true, 50, 50);
		
		add(base);
		add(ojos);
	}
}