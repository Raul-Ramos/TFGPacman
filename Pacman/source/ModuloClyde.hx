package ;

import flixel.FlxObject;

/**
 * ...
 * @author Goldy
 */
class ModuloClyde extends Modulo
{
	private var pacman:Pacman;
	
	public function new(mapa:Array<Array<Int>>, pacman:Pacman) {
		super(mapa);
		
		this.tipoIA = TipoIA.Clyde;
		this.pacman = pacman;
	}
	
	override private function decidirCamino(facing:Int):Int {
		var xObjetivo:Int = Math.floor(pacman.getMidpoint().x / 50);
		var yObjetivo:Int = Math.floor(pacman.getMidpoint().y / 50);
		
		var xthis:Int = Math.floor(fantasma.getMidpoint().x / 50);
		var ythis:Int = Math.floor(fantasma.getMidpoint().y / 50);
		
		//Pasivo
		if(Math.sqrt(((xObjetivo - xthis) * (xObjetivo - xthis))
		+ ((yObjetivo - ythis) * (yObjetivo - ythis))) <= 4 ) {
			yObjetivo = mapa.length - 1;
			xObjetivo = 0;
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