package ;

import flixel.FlxSprite;
import flixel.FlxObject;
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
	private var pasoDecidido:Bool = false;

	public function new(X:Float = 0, Y:Float = 0, moduloIa:Modulo.Modulo) 
	{
		super(X, Y);
		
		moduloIa.setFantasma(this);
		this.ia = moduloIa;
		
		base = new FlxSprite();
		ojos = new FlxSprite();
		base.loadGraphic(AssetPaths.fantasma__png, true, 50, 50, true);
		
		var colorF:String = ia.getColor();
		if (colorF != null && colorF.toLowerCase() != "0xffff0000") {
			base.replaceColor(Std.parseInt("0xffff0000"), Std.parseInt(colorF), true);
		}
		
		ojos.loadGraphic(AssetPaths.ojos__png, true, 50, 50);
		
		add(base);
		add(ojos);
		
		maxVelocity.x = maxVelocity.y = 150;
		velocity.x = maxVelocity.x;
		facing = FlxObject.RIGHT;
	}
	
	override public function update():Void
	{
		super.update();
		
		if(getMidpoint().x % 50 >= 23 && getMidpoint().x % 50 <= 27
		&& getMidpoint().y % 50 >= 23 && getMidpoint().y % 50 <= 27) {
			if (!pasoDecidido) {
				
				//Decide el paso
				facing = ia.movimientoRegular();
					
				switch(facing) {
					case FlxObject.UP:
						velocity.x = 0;
						velocity.y = -maxVelocity.y;
					case FlxObject.RIGHT:
						velocity.x = maxVelocity.x;
						velocity.y = 0;
					case FlxObject.DOWN:
						velocity.x = 0;
						velocity.y = maxVelocity.y;
					case FlxObject.LEFT:
						velocity.x = -maxVelocity.x;
						velocity.y = 0;
					default:
						velocity.x = velocity.y = 0;
				}
					
				//Se indica que el paso ha sido tomado
				pasoDecidido = true;
			}
		}else if(pasoDecidido){
			//Permite decidir el paso
			pasoDecidido = false;
		}
	}
}