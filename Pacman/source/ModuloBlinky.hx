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
	
	private var puntosElroy:Array<Array<Int>> = [
	[1,2,3,6,9,12,15,19],
	[20,30,40,50,60,80,100,120]];
	private var velocidadElroy:Array<Array<Int>> = [
	[1,2,5],
	[80,90,100]];
	
	public function new(mapa:Array<Array<Int>>, pacman:Pacman) {
		super(mapa);
		this.pacman = pacman;
	}
	
	//TODO: MODO BERSERK
	
	override private function decidirCamino(facing:Int):Int {
		
		//TODO: Evitarse el 50
		//TODO: Lo mismo si pacman tiene funcion que devuelva
		//posición en la tabla sale mas a cuenta
		var xObjetivo:Int = Math.floor(pacman.getMidpoint().x / 50);
		var yObjetivo:Int = Math.floor(pacman.getMidpoint().y / 50);
		
		var xthis:Int = Math.floor(fantasma.getMidpoint().x / 50);
		var ythis:Int = Math.floor(fantasma.getMidpoint().y / 50);

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