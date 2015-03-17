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
	
	private var frightBlue:Bool;

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
		
		base.animation.add("andar", [0, 1], 15, true);
		base.animation.add("andarUP", [2, 3], 15, true);
		base.animation.add("panicoB", [4, 5], 15, true);
		base.animation.add("panicoW", [6, 7], 15, true);
		
		
		
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
				
				decidirAnimacion();
				
				switch(facing) {
					case FlxObject.UP:
						velocity.x = 0;
						velocity.y = -maxVelocity.y;
						ojos.animation.frameIndex = 3;
					case FlxObject.RIGHT:
						velocity.x = maxVelocity.x;
						velocity.y = 0;
						ojos.animation.frameIndex = 0;
					case FlxObject.DOWN:
						velocity.x = 0;
						velocity.y = maxVelocity.y;
						ojos.animation.frameIndex = 1;
					case FlxObject.LEFT:
						velocity.x = -maxVelocity.x;
						velocity.y = 0;
						ojos.animation.frameIndex = 2;
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
	
	private function decidirAnimacion():Void
	{
		if (ia.isFrightened()) {
			//TODO: OPT - Quizá variable local de Frightened?
			//TOOO: OPT - Quizá contador local BW?
			if (frightBlue) { base.animation.play("panicoB"); }
			else { base.animation.play("panicoW"); }
		}else {
			if (facing == FlxObject.UP) {
				base.animation.play("andarUP");
			} else {
				base.animation.play("andar");
			}
		}
	}
	
	public function iniciarFrightMode():Void
	{
		ia.setFrightened(true);
		ojos.alpha = 0;
		frightBlue = true;
		decidirAnimacion();
	}
	
	public function acabarFrightMode():Void
	{
		ia.setFrightened(false);
		ojos.alpha = 1;
		decidirAnimacion();
	}
	
	public function alternarBW():Void
	{
		if (frightBlue) {
			frightBlue = false;
		} else {
			frightBlue = true;
		}
		decidirAnimacion();
	}
	
	public function getIA():Modulo
	{
		return ia;
	}
}