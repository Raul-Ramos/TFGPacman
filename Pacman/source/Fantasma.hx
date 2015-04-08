package ;

import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxPoint;

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
	private var currentVelocity:Float;
	
	private var velocidadNormal:Float = -1;

	public function new(X:Float = 0, Y:Float = 0, velocidad:Float, moduloIa:Modulo.Modulo) 
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

		maxVelocity.x = currentVelocity = velocidad;
		facing = FlxObject.RIGHT;
	}
	
	override public function update():Void
	{
		super.update();
		
		var midX:Int = Std.int(Math.abs(getMidpoint().x));
		var midY:Int = Std.int(Math.abs(getMidpoint().y));
		
		if(midX % 50 >= 23 && midX % 50 <= 27
		&& midY % 50 >= 23 && midY % 50 <= 27) {
			
			//Comportamiento fuera de los bordes
			if (midX >= (ia.getMapa()[0].length) * 50) {
				if (facing == FlxObject.RIGHT) {
					x = -50;
				}
			} else if (x < -23) {
				if (facing == FlxObject.LEFT) {
					x = ia.getMapa()[0].length * 50;
				}
				
			} // Si dentro de los bordes, decide paso 
			else if (!pasoDecidido) {
				
				if (ia.getMapa()[Math.floor(midY / 50)][Math.floor(midX / 50)] == -1) {
					if (currentVelocity == maxVelocity.x) {
						currentVelocity *= 0.4;
					}
				} else if (currentVelocity != maxVelocity.x) {
					currentVelocity = maxVelocity.x;
				}
				
				//Decide el paso
				facing = ia.movimientoRegular();
				
				decidirAnimacion();
				
				switch(facing) {
					case FlxObject.UP:
						velocity.x = 0;
						velocity.y = -currentVelocity;
						ojos.animation.frameIndex = 3;
					case FlxObject.RIGHT:
						velocity.x = currentVelocity;
						velocity.y = 0;
						ojos.animation.frameIndex = 0;
					case FlxObject.DOWN:
						velocity.x = 0;
						velocity.y = currentVelocity;
						ojos.animation.frameIndex = 1;
					case FlxObject.LEFT:
						velocity.x = -currentVelocity;
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
	
	public function iniciarFrightMode(velocidad:Float):Void
	{
		velocidadNormal = maxVelocity.x;
		maxVelocity.x = velocidad;
		if (currentVelocity > maxVelocity.x) {
			currentVelocity = maxVelocity.x;
		}
		
		ia.setFrightened(true);
		ojos.alpha = 0;
		frightBlue = true;
		decidirAnimacion();
	}
	
	public function acabarFrightMode():Void
	{
		maxVelocity.x = velocidadNormal;
		if (currentVelocity == maxVelocity.x) {
			setCurrentVelocity(maxVelocity.x);
		}
		
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
	
	//Se coloca el fantasma en la puerta. 
	//vX y vY son -1 o 1 dependiendo de la dirección que se tenga que
	//tomar para salir.
	public function liberar(puerta:FlxPoint, vX:Int, vY:Int):Void
	{
		x = (puerta.x * 50) - (vX * 50);
		y = (puerta.y * 50) - (vY * 50);
		velocity.x = vX * maxVelocity.x * 0.4;
		velocity.y = vY * maxVelocity.x * 0.4;
	}
	
	public function matar() {
		base.set_alpha(0);
		acabarFrightMode();
		decidirAnimacion();
	}
	
	public function revivir() {
		base.set_alpha(1);
	}
	
	public function getIA():Modulo
	{
		return ia;
	}
	
	public function getCurrentVelocity():Float {
		return currentVelocity;
	}
	
	public function setCurrentVelocity(vel:Float):Void
	{
		currentVelocity = vel;
	}
}