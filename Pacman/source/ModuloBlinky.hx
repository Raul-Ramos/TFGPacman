package ;

import flixel.FlxObject;

/**
 * ...
 * @author Goldy
 */
class ModuloBlinky extends Modulo
{
	private var pacman:Pacman;
	
	public function new(mapa:Array<Array<Int>>, pacman:Pacman) {
		super(mapa);
		this.pacman = pacman;
	}
	
	//TODO: MODO BERSERK
	
	override private function decidirCamino(facing:Int):Int {
		
		//TODO: Evitarse el 50
		//TODO: Lo mismo si pacman tiene funcion que devuelva
		//posición en la tabla sale mas a cuenta
		var xpac:Int = Math.floor(pacman.getMidpoint().x / 50);
		var ypac:Int = Math.floor(pacman.getMidpoint().y / 50);
		
		var xthis:Int = Math.floor(fantasma.getMidpoint().x / 50);
		var ythis:Int = Math.floor(fantasma.getMidpoint().y / 50);
		
		var mejorOpcion:Int = FlxObject.NONE;
		var mejorDistancia:Float = 0;
		var distancia:Float;
		var posX:Int = xthis;
		var posY:Int = ythis - 1;
		
		//IMPORTANTE: Esta parte está preparada para dar
		//preferencia, en este orden, a up, left, down, right.
		//Así se procesa en el modelo original, no cambiar.
		
		//Arriba
		if (facing != FlxObject.DOWN && mapa[posY][posX] == 0) {
			mejorOpcion = FlxObject.UP;
			mejorDistancia = Math.sqrt(((xpac - posX) * (xpac - posX)) + 
			((ypac - posY) * (ypac - posY)));
		}
		
		//Izquierda
		posX -= 1;
		posY += 1;
		if (facing != FlxObject.RIGHT && mapa[posY][posX] == 0) {
			distancia = Math.sqrt(((xpac - posX) * (xpac - posX)) + 
			((ypac - posY) * (ypac - posY)));
			
			if (mejorOpcion == FlxObject.NONE ||
			(mejorOpcion == FlxObject.UP && distancia < mejorDistancia)) {
				mejorOpcion = FlxObject.LEFT;
				mejorDistancia = distancia;
			}
		}
		
		//Abajo
		posX += 1;
		posY += 1;
		if (facing != FlxObject.UP && mapa[posY][posX] == 0) {
			distancia = Math.sqrt(((xpac - posX) * (xpac - posX)) + 
			((ypac - posY) * (ypac - posY)));
			
			if (mejorOpcion == FlxObject.NONE || 
			(mejorOpcion!=FlxObject.NONE && distancia < mejorDistancia)) {
				mejorOpcion = FlxObject.DOWN;
				mejorDistancia = distancia;
			}
		}
		
		//Derecha
		posX += 1;
		posY -= 1;
		if (facing != FlxObject.LEFT && mapa[posY][posX] == 0) {
			distancia = Math.sqrt(((xpac - posX) * (xpac - posX)) + 
			((ypac - posY) * (ypac - posY)));
			
			if (distancia < mejorDistancia) {
				mejorOpcion = FlxObject.RIGHT;
			}
		}
		
		return mejorOpcion;
	}
}