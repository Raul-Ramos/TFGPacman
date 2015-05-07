package ;

import flixel.FlxObject;
import Pathfinding;
import flixel.group.FlxTypedGroup;

/**
 * ...
 * @author Goldy
 */
class ModuloBlinky extends Modulo
{
	private var pacman:Pacman;
	
	private var puntosElroyN:Array<Array<Int>> = [
	[1,2,3,6,9,12,15,19],
	[20,30,40,50,60,80,100,120]];
	private var velocidadElroyN:Array<Array<Int>> = [
	[1,2,5],
	[80, 90, 100]];
	
	private var velocidadElroy1:Float;
	private var velocidadElroy2:Float;
	private var puntosElroy1:Int;
	private var puntosElroy2:Int;
	private var estadoElroy:Int = 0;
	private var dots:FlxTypedGroup<Dot>;
	
	public function new(mapa:Array<Array<Int>>, pacman:Pacman, gv:GestorValoresJuego, dots:FlxTypedGroup<Dot>) {
		super(mapa);
		
		this.tipoIA = TipoIA.Blinky;
		this.pacman = pacman;
		this.dots = dots;
		
		var velocidadNormal = gv.getVelocidadBase();
		
		velocidadElroy1 = velocidadNormal * (gv.getForThisLevel(velocidadElroyN) / 100);
		velocidadElroy2 = velocidadNormal * ((gv.getForThisLevel(velocidadElroyN) + 5) / 100);
		
		puntosElroy1 = gv.getForThisLevel(puntosElroyN);
		puntosElroy2 = Std.int(puntosElroy1 / 2);
	}
	
	private function elroy():Void {
		if (estadoElroy < 2) {
			if (estadoElroy < 1) {
				//Paso a elroy 1
				if (dots.countLiving() <= puntosElroy1) {
					estadoElroy = 1;
					acelerarElroy();
				} 
			} else {
				//Paso a elroy 2
				if (dots.countLiving() <= puntosElroy2) {
					estadoElroy = 2;
					acelerarElroy();
				}
			}
		}
	}
	
	private function acelerarElroy():Void {
		if (estadoElroy == 1) {
			
			if (fantasma.getCurrentVelocity() == fantasma.maxVelocity.x) {
				fantasma.setCurrentVelocity(velocidadElroy1);
			}
			fantasma.maxVelocity.x = velocidadElroy1;
			
		} else if (estadoElroy == 2) {
			
			if (fantasma.getCurrentVelocity() == fantasma.maxVelocity.x) {
				fantasma.setCurrentVelocity(velocidadElroy2);
			}
			fantasma.maxVelocity.x = velocidadElroy2;
			
		}
	}
	
	override private function decidirCamino(facing:Int):Int {
		
		//TODO: Evitarse el 50
		//TODO: Lo mismo si pacman tiene funcion que devuelva
		//posición en la tabla sale mas a cuenta
		var xObjetivo:Int = Math.floor(pacman.getMidpoint().x / 50);
		var yObjetivo:Int = Math.floor(pacman.getMidpoint().y / 50);
		
		var xthis:Int = Math.floor(fantasma.getMidpoint().x / 50);
		var ythis:Int = Math.floor(fantasma.getMidpoint().y / 50);
		
		elroy();
		
		return Pathfinding.metodoTradicional(mapa, xthis, ythis, xObjetivo, yObjetivo, facing);
	}
	
	override private function caminoScatter(facing:Int):Int {
		
		if(estadoElroy == 0) {
			var xObjetivo:Int = Std.int(esquina.x);
			var yObjetivo:Int = Std.int(esquina.y);
			
			var xthis:Int = Math.floor(fantasma.getMidpoint().x / 50);
			var ythis:Int = Math.floor(fantasma.getMidpoint().y / 50);
			
			elroy();
			
			return Pathfinding.metodoTradicional(mapa, xthis, ythis, xObjetivo, yObjetivo, facing);
		
		} else {
			//Si está en elroy, siempre va a por Pacman
			return decidirCamino(facing);
		}
	}
	
	override public function setFrightened(asustado:Bool):Void
	{ 
		super.setFrightened(asustado);
		if (asustado == false){
			acelerarElroy();
		}
	}
}