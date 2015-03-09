package ;
import flixel.util.FlxPoint;
import haxe.ds.Vector;

/**
 * ...
 * @author Goldy
 */
class Pathfinding
{
	static public function astar(inicio:FlxPoint, final:FlxPoint, mapa:Array<Int>):Void
	{
		var abiertos:Array<Nodo> = new Array<Nodo>();
		var cerrados:Array<Nodo> = new Array<Nodo>();
		
		var finalX:Int = Std.int(final.x);
		var finalY:Int = Std.int(final.y);
		
		var nodoInicial:Nodo = new Nodo();
		nodoInicial.x = Std.int(inicio.x);
		nodoInicial.y = Std.int(inicio.y);
		nodoInicial.coste = 0;
		nodoInicial.costeH = 0;
		nodoInicial.padre = null;
		abiertos.push(nodoInicial);
		
		var x, y:Int;
		var eucli:Float;
		var nodoT:Nodo = new Nodo();
		var nodoA:Nodo = new Nodo();
		var found:Bool;
		while (abiertos.length > 0) {
			
			var se:String = "";
			for (i in abiertos) {
				se += "[" + i.x + "," + i.y + "," + i.costeH + "]";
			}
			trace(se);
			
			//Seleccion del mejor nodo abierto
			var nodoT = abiertos[0];
			for (i in 1...abiertos.length) {
				if (abiertos[i].costeH < nodoT.costeH) {
					nodoT = abiertos[i];
				}
			}
			
			//Si es la solucion
			if (nodoT.x == finalX && nodoT.y == finalY) {
				devolverCamino(nodoT);
				break;
			}
			
			abiertos.remove(nodoT);
			cerrados.push(nodoT);
			
			x = nodoT.x + 1;
			y = nodoT.y;
			
			for (i in 0...4) {
				//Comprueba los 4 vecinos, optimizado
				switch(i) {
					case 1:
						x -= 2;
					case 2:
						x += 1;
						y += 1;
					case 3:
						y -= 2;
				}
				
				//Revisa que no sea pared
				if (mapa[(y * 21) + x] != 0) {
					//Especial de Pacman
					//Si la pared es el objetivo, esta es la solución
					if (x == finalX && y == finalY) {
						devolverCamino(nodoT);
						break;
					} else {
						continue;
					}
				}
				
				found = false;
				//Revisa que no está cerrado
				for (i in cerrados) {
					if ( i.x == x && i.y == y) {
						found = true;
						break;
					}
				}
				if (found) {
					continue;
				}
				
				//distancia euclidiana
				eucli = Math.sqrt(((finalX - x) * (finalY - x)) + ((finalY - y) * (finalY - y)));
				
				nodoA = null;
				for (i in abiertos) {
					if (i.x == x && i.y == y) {
						if (i.costeH > nodoT.coste + 1 + eucli) {
							nodoA = i;
						} else {
							found = true;
						}
						break;
					}
				}
				
				if (found) {
					continue;
				} else if (nodoA == null) {
					nodoA = new Nodo();
					nodoA.x = x;
					nodoA.y = y;
					found = true;
				}
				
				nodoA.coste = nodoT.coste + 1;
				nodoA.costeH = nodoA.coste + eucli;
				nodoA.padre = nodoT;
				
				if (found) { //No sé si hace falta
					abiertos.push(nodoA);
				}
			}
		}
		trace("boh");
	}
	
	static private function devolverCamino(nodoF:Nodo):Void {
		var nodoP:Nodo = nodoF;
		var f:String = "";
		while (nodoP != null) {
			f = nodoP.x + "," + nodoP.y + "->" + f;
			nodoP = nodoP.padre;
		}
		trace(f);
		return null;
	}
}

class Nodo {
	public var x:Int;
	public var y:Int;
	public var coste:Int;
	public var costeH:Float;
	public var padre:Nodo;
	
	public function new() {
	}
}