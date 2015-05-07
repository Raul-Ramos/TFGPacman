package ;

import flixel.FlxObject;
import Pathfinding;

/**
 * ...
 * @author Goldy
 */
class ModuloInky extends Modulo
{
	private var pacman:Pacman;
	private var blinky:Fantasma;
	
	public function new(mapa:Array<Array<Int>>, pacman:Pacman, blinky:Fantasma) {
		super(mapa);
		this.tipoIA = TipoIA.Inky;
		this.pacman = pacman;
		this.blinky = blinky;
	}
	
	override private function decidirCamino(facing:Int):Int {
		
		//TODO: Evitarse el 50
		//TODO: Lo mismo si pacman tiene funcion que devuelva
		//posición en la tabla sale mas a cuenta
		var xObjetivo:Int = Math.floor(pacman.getMidpoint().x / 50);
		var yObjetivo:Int = Math.floor(pacman.getMidpoint().y / 50);
		
		var xthis:Int = Math.floor(fantasma.getMidpoint().x / 50);
		var ythis:Int = Math.floor(fantasma.getMidpoint().y / 50);
		
		var xBlinky:Int = Math.floor(blinky.getMidpoint().x / 50);
		var yBlinky:Int = Math.floor(blinky.getMidpoint().y / 50);
		
		switch(facing) {
			case FlxObject.UP:
				yObjetivo -= 2;
			case FlxObject.DOWN:
				yObjetivo += 2;
			case FlxObject.LEFT:
				xObjetivo -= 2;
			case FlxObject.RIGHT:
				xObjetivo += 2;
		}
		
		xObjetivo += xObjetivo - xBlinky;
		yObjetivo += yObjetivo - yBlinky;
		
		switch(facing) {
			case FlxObject.UP:
				if (yObjetivo < 0) {
					yObjetivo = 0;
				}
			case FlxObject.DOWN:
				if (yObjetivo > mapa.length - 1) {
					yObjetivo = mapa.length - 1;
				}
			case FlxObject.LEFT:
				if (xObjetivo < 0) {
					xObjetivo = 0;
				}
			case FlxObject.RIGHT:
				if (xObjetivo > mapa[0].length - 1) {
					xObjetivo = mapa[0].length - 1;
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