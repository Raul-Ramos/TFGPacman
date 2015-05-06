package ;

import flixel.FlxObject;
import Pathfinding;

/**
 * ...
 * @author Goldy
 */
class ModuloPinky extends Modulo
{
	private var pacman:Pacman;

	public function new(mapa:Array<Array<Int>>, pacman:Pacman) {
		super(mapa);
		this.pacman = pacman;
	}
	
	override public function getColor():String
	{
		return "0xffff9cce";
	}
	
	override public function getNombre():String
	{
		return "Pinky";
	}
	
	override private function decidirCamino(facing:Int):Int {
		
		//TODO: Evitarse el 50
		//TODO: Lo mismo si pacman tiene funcion que devuelva
		//posición en la tabla sale mas a cuenta
		var xObjetivo:Int = Math.floor(pacman.getMidpoint().x / 50);
		var yObjetivo:Int = Math.floor(pacman.getMidpoint().y / 50);
		
		var xthis:Int = Math.floor(fantasma.getMidpoint().x / 50);
		var ythis:Int = Math.floor(fantasma.getMidpoint().y / 50);
		
		switch(facing) {
			case FlxObject.UP:
				if (yObjetivo - 2 < 0) {
					yObjetivo = 0;
				} else {
					yObjetivo -= 2;
				}
			case FlxObject.DOWN:
				if (yObjetivo + 2 > mapa.length - 1) {
					yObjetivo = mapa.length - 1;
				} else {
					yObjetivo += 2;
				}
			case FlxObject.LEFT:
				if (xObjetivo - 2 < 0) {
					xObjetivo = 0;
				} else {
					xObjetivo -= 2;
				}
			case FlxObject.RIGHT:
				if (xObjetivo + 2 > mapa[0].length - 1) {
					xObjetivo = mapa[0].length - 1;
				} else {
					xObjetivo += 2;
				}
		}
		
		return Pathfinding.metodoTradicional(mapa, xthis, ythis, xObjetivo, yObjetivo, facing);
	}
	
	override private function caminoScatter(facing:Int):Int{
		var xObjetivo:Int = Std.int(esquina.x);
		var yObjetivo:Int = Std.int(esquina.y);
		
		var xthis:Int = Math.floor(fantasma.getMidpoint().x / 50);
		var ythis:Int = Math.floor(fantasma.getMidpoint().y / 50);
		
		return Pathfinding.metodoTradicional(mapa, xthis, ythis, xObjetivo, yObjetivo, facing);
	}
}