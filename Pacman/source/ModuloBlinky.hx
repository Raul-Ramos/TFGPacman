package ;

import flixel.FlxObject;
import Pathfinding;

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
		
		return Pathfinding.metodoTradicional(mapa, xthis, ythis, xpac, ypac, facing);
	}
}