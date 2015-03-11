package ;
import flixel.util.FlxPoint;
import haxe.ds.Vector;
import flixel.FlxObject;

/**
 * ...
 * @author Goldy
 */
class Pathfinding
{	
	//Lo mismo esto está mejor como una funcion privada de una clase padre de los fantasmas comunes. Qué se yo.
	static public function metodoTradicional(mapa:Array<Array<Int>>, oriX:Int, oriY:Int, desX:Int, desY:Int, facing:Int):Int {
		var mejorOpcion:Int = FlxObject.NONE;
		var mejorDistancia:Float = 0;
		var distancia:Float;
		var posX:Int = oriX;
		var posY:Int = oriY - 1;
		
		//IMPORTANTE: Esta parte está preparada para dar
		//preferencia, en este orden, a up, left, down, right.
		//Así se procesa en el modelo original, no cambiar.
		
		//Arriba
		if (facing != FlxObject.DOWN && mapa[posY][posX] == 0) {
			mejorOpcion = FlxObject.UP;
			mejorDistancia = Math.sqrt(((desX - posX) * (desX - posX)) + 
			((desY - posY) * (desY - posY)));
		}
		
		//Izquierda
		posX -= 1;
		posY += 1;
		if (facing != FlxObject.RIGHT && mapa[posY][posX] == 0) {
			distancia = Math.sqrt(((desX - posX) * (desX - posX)) + 
			((desY - posY) * (desY - posY)));
			
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
			distancia = Math.sqrt(((desX - posX) * (desX - posX)) + 
			((desY - posY) * (desY - posY)));
			
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
			distancia = Math.sqrt(((desX - posX) * (desX - posX)) + 
			((desY - posY) * (desY - posY)));
			
			if (distancia < mejorDistancia) {
				mejorOpcion = FlxObject.RIGHT;
			}
		}
		
		return mejorOpcion;
	}
	
	static public function astar(inicio:FlxPoint, final:FlxPoint, mapa:Array<Array<Int>>):String
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
			
			/*var se:String = "";
			for (i in abiertos) {
				se += "[" + i.x + "," + i.y + "," + i.costeH + "]";
			}
			trace(se);*/
			
			//Seleccion del mejor nodo abierto
			var nodoT = abiertos[0];
			for (i in 1...abiertos.length) {
				if (abiertos[i].costeH < nodoT.costeH) {
					nodoT = abiertos[i];
				}
			}
			
			//trace("tomado: " + nodoT.x, nodoT.y, nodoT.costeH);
			
			//Si es la solucion
			if (nodoT.x == finalX && nodoT.y == finalY) {
				return devolverCamino(nodoT);
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
				if (mapa[y][x] != 0) {
					//Especial de Pacman
					//Si la pared es el objetivo, esta es la solución
					if (x == finalX && y == finalY) {
						return devolverCamino(nodoT);
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
				eucli = Math.sqrt(((finalX - x) * (finalX - x)) + ((finalY - y) * (finalY - y)));
				
				//Quizá nunca hay substitucion
				nodoA = null;
				for (i in abiertos) {
					if (i.x == x && i.y == y) {
						if (i.costeH > nodoT.coste + 1 + eucli) {
							nodoA = i;
							trace("subs");
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
		return null;
	}
	
	static private function devolverCamino(nodoF:Nodo):String {
		var nodoP:Nodo = nodoF;
		var f:String = "";
		while (nodoP != null) {
			f = nodoP.x + "," + nodoP.y + "->" + f;
			nodoP = nodoP.padre;
		}
		return f;
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