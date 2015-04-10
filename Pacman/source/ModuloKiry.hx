package ;

import flixel.FlxObject;
import Pathfinding;
import flixel.util.FlxPoint;

/**
 * ...
 * @author Goldy
 */
class ModuloKiry extends Modulo
{
	private var pacman:Pacman;
	private var pressMap:Array<Array<Float>>;
	
	public function new(mapa:Array<Array<Int>>, pacman:Pacman) {
		super(mapa);
		this.pacman = pacman;
		
		var mapaPresion:MapaPresion = new MapaPresion(mapa);
		this.pressMap = mapaPresion.getMapa();
	}
	
	override public function getColor():String
	{
		return "0xff9142ad";
	}
	
	override private function decidirCamino(facing:Int):Int {
		
		var xpacman:Int = Math.floor(pacman.getMidpoint().x / 50);
		var ypacman:Int = Math.floor(pacman.getMidpoint().y / 50);
		var xthis:Int = Math.floor(fantasma.getMidpoint().x / 50);
		var ythis:Int = Math.floor(fantasma.getMidpoint().y / 50);
		
		var entorno:Array<Array<Float>> = detectarEntorno();
		
		var maximo:Float = -1;
		var mx:Int = -1;
		var my:Int = -1;
		for (yo in 0...entorno.length) {
			for (xo in 0...entorno[yo].length) {
				if (entorno[yo][xo] > maximo) {
					maximo = entorno[yo][xo];
					mx = xo;
					my = yo;
				}
			}
		}
		
		var origenXY:FlxPoint = new FlxPoint(xpacman, ypacman);
		var destinoXY:FlxPoint = new FlxPoint(xpacman-Std.int((entorno.length - 1)/2) + mx, ypacman - Std.int((entorno.length - 1) / 2) + my);
		
		var valorC:Int = mapa[ypacman][xpacman];
		mapa[ypacman][xpacman] = 1;
		
		var res:Int = Pathfinding.astar(origenXY, destinoXY, mapa);
		
		switch(res) {
			case FlxObject.RIGHT:
				destinoXY.set(xpacman - 1, ypacman);
			case FlxObject.LEFT:
				destinoXY.set(xpacman + 1, ypacman);
			case FlxObject.UP:
				destinoXY.set(xpacman, ypacman - 1);
			case FlxObject.DOWN:
				destinoXY.set(xpacman, ypacman + 1);
			default:
				destinoXY.set(xpacman, ypacman);
		}
		origenXY.set(xthis, ythis);
		
		res = Pathfinding.astar(origenXY, destinoXY, mapa);
		
		if (res == FlxObject.ANY) {
			res = Pathfinding.metodoTradicional(mapa, xthis, ythis, xpacman, ypacman, facing);
		}

		mapa[ypacman][xpacman] = valorC;
		
		return res;
	}
	
	override private function caminoScatter(facing:Int):Int{
		var xObjetivo:Int = Std.int(esquina.x);
		var yObjetivo:Int = Std.int(esquina.y);
		
		var xthis:Int = Math.floor(fantasma.getMidpoint().x / 50);
		var ythis:Int = Math.floor(fantasma.getMidpoint().y / 50);
		
		return Pathfinding.metodoTradicional(mapa, xthis, ythis, xObjetivo, yObjetivo, facing);
	}
	
	private function detectarEntorno(radio:Int = 4):Array<Array<Float>> {
		var nodosAbiertos:Array<FlxPoint> = new Array<FlxPoint>();
		var posiciones:Array<FlxPoint> = new Array<FlxPoint>();
		var nodosCerrados:Array<FlxPoint> = new Array<FlxPoint>();
		
		var entorno:Array<Array<Float>> = new Array<Array<Float>>();
		for (yo in 0...(radio * 2) + 1) {
			var fila:Array<Float> = new Array<Float>();
			for (xo in 0...(radio * 2) + 1) {
				fila.push( -1);
			}
			entorno.push(fila);
		}
		
		var posX:Int = Math.floor(pacman.getMidpoint().x / 50);
		var PosY:Int = Math.floor(pacman.getMidpoint().y / 50);
		nodosAbiertos.push(new FlxPoint(posX,PosY));
		posiciones.push(new FlxPoint(radio, radio));
		
		var nodo, posicion:FlxPoint;
		var px, py, nx, ny:Int;
		var found:Bool;
		while (nodosAbiertos.length > 0) {
			nodo = nodosAbiertos.pop();
			posicion = posiciones.pop();
			
			posX = Std.int(nodo.x);
			PosY = Std.int(nodo.y);
			
			if (mapa[PosY][posX] < 1) {
				px = Std.int(posicion.x);
				py = Std.int(posicion.y);
				entorno[py][px] = pressMap[PosY][posX];
				
				if (px > 0) {
					nx = posX - 1;
					if (nx < 0) nx = mapa[0].length - 1;
					if (!nodoRepetido(nodosAbiertos,nx,PosY) && !nodoRepetido(nodosCerrados,nx,PosY)) {
						nodosAbiertos.push(new FlxPoint(nx, PosY));
						posiciones.push(new FlxPoint(px - 1,py));
					}
				}
				
				if (px < entorno.length - 1) {
					nx = posX + 1;
					if (nx > mapa[0].length - 1) nx = 0;
					if (!nodoRepetido(nodosAbiertos,nx,PosY) && !nodoRepetido(nodosCerrados,nx,PosY)) {
						nodosAbiertos.push(new FlxPoint(nx, PosY));
						posiciones.push(new FlxPoint(px + 1, py));
					}
				}
				
				if (py > 0) {
					ny = PosY - 1;
					if (ny < 0) ny = mapa.length - 1;
					if (!nodoRepetido(nodosAbiertos,posX,ny) && !nodoRepetido(nodosCerrados,posX,ny)) {
						nodosAbiertos.push(new FlxPoint(posX, ny));
						posiciones.push(new FlxPoint(px, py - 1));
					}
				}
				
				if (py < entorno.length - 1) {
					ny = PosY + 1;
					if (ny > mapa.length - 1) ny = 0;
					if (!nodoRepetido(nodosAbiertos,posX,ny) && !nodoRepetido(nodosCerrados,posX,ny)) {
						nodosAbiertos.push(new FlxPoint(posX, ny));
						posiciones.push(new FlxPoint(px,py + 1));
					}
				}
			}
			
			nodosCerrados.push(nodo);
		}
		
		return entorno;
	}
	
	private function nodoRepetido(nodos:Array<FlxPoint>, x, y) {
		for ( i in nodos) {
			if (i.x == x && i.y == y) {
				return true;
			}
		}
		return false;
	}
	
}