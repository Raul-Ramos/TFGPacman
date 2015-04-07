package  ;
import flixel.FlxObject;
import flixel.util.FlxPoint;

/**
 * ...
 * @author Goldy
 */
class MapaPresion
{
	private var pressMap:Array<Array<Float>>;
	
	public function new(mapa:Array<Array<Int>>) 
	{
		
		//////////Crea el mapa de presión//////////
		pressMap = new Array<Array<Float>>();
		var linea:Array<Float>;
		for (y in 0...mapa.length) {
			linea = new Array<Float>();
			for (x in 0...mapa[0].length) {
				if (mapa[y][x] < 1) {
					linea[x] = 0;
				} else {
					linea[x] = -1;
				}
			}
			pressMap[y] = linea;
		}
		
		var vertices:Array<Vertice> = new Array<Vertice>();
		var up, down, left, right,cantidad:Int;
		
		//////////Crea los vertices//////////
		for (y in 1...mapa.length - 1) {
			for (x in 1...mapa[y].length - 1) {
				if (mapa[y][x] < 1) {
					cantidad = 0;
					
					if (mapa[y - 1][x] < 1) cantidad++;
					if (mapa[y + 1][x] < 1) cantidad++;
					if (mapa[y][x + 1] < 1) cantidad++;
					if (mapa[y][x - 1] < 1) cantidad++;
					
					if (cantidad > 2) {
						
						//-2 To do
						up = if (mapa[y - 1][x] < 1) -2 else -1;
						down =  if (mapa[y + 1][x] < 1) -2 else -1;
						left = if (mapa[y][x - 1] < 1) -2 else -1;
						right = if (mapa[y][x +1 ] < 1) -2 else -1;
						
						vertices.push(new Vertice(x, y, up, down, left, right));
					}
				}
			}
		}
		
		var posX, posY, from, found:Int;
		var camino:Array<FlxPoint>;
		
		//////////Busca conexiones entre vectores para crear grafo//////////
		for (v in 0...vertices.length) {
			var vertice:Vertice = vertices[v];
			for (i in 0...vertice.vecinos.length) {
				camino = new Array<FlxPoint>();
				
				if (vertice.vecinos[i] == -2) {
					posX = vertice.x;
					posY = vertice.y;
					
					
					switch(i) {
						case 0:
							from = FlxObject.DOWN;
							posY--;
						case 1:
							from = FlxObject.UP;
							posY++;
						case 2:
							from = FlxObject.RIGHT;
							posX--;
						default:
							from = FlxObject.LEFT;
							posX++;
					}
				
					while (vertice.vecinos[i] == -2) {
						
						if (posX < 0) posX = mapa[0].length - 1;
						if (posX > mapa[0].length - 1) posX = 0;
						if (posY < 0) posY = mapa.length - 1;
						if (posY > mapa.length - 1) posY = 0;
						
						camino.push(new FlxPoint(posX, posY));
						
						found = -1;
						for (z in 0...vertices.length) {
							if (vertices[z].x == posX && vertices[z].y == posY) {
								found = z;
								break;
							}
						}
						
						//Si no se ha encontrado
						if (found == -1) {
							if (from != FlxObject.DOWN && mapa[posY+1][posX] < 1) {
								from = FlxObject.UP;
								posY++;
							} else if (from != FlxObject.UP && mapa[posY-1][posX] < 1) {
								from = FlxObject.DOWN;
								posY--;
							} else if (from != FlxObject.LEFT && mapa[posY][posX-1] < 1) {
								from = FlxObject.RIGHT;
								posX--;
							} else if (from != FlxObject.RIGHT && mapa[posY][posX+1] < 1) {
								from = FlxObject.LEFT;
								posX++;
							} else {
								vertice.vecinos[i] = -1;
								vertice.caminoVecinos[i] = camino;
							}
						}
						//Si se ha encontrado
						else {
							vertice.vecinos[i] = found;
							vertice.caminoVecinos[i] = camino;
							switch (from) {
								case FlxObject.UP:
									vertices[found].vecinos[0] = v;
									vertices[found].caminoVecinos[0] = invertirArray(camino, vertice);
								case FlxObject.DOWN:
									vertices[found].vecinos[1] = v;
									vertices[found].caminoVecinos[1] = invertirArray(camino, vertice); 
								case FlxObject.LEFT:
									vertices[found].vecinos[2] = v;
									vertices[found].caminoVecinos[2] = invertirArray(camino, vertice); 
								default:
									vertices[found].vecinos[3] = v;
									vertices[found].caminoVecinos[3] = invertirArray(camino, vertice); 
							}
						}
					}
				}
			}
		}
		
		//////////Crea un grafo para busqueda de componentes biconectados//////////
		var time:Int = 0;
		var verticesBC:Array<VerticeBC> = new Array<VerticeBC>();
		for (v in 0...vertices.length) {
			verticesBC.push(new VerticeBC(vertices[v]));
		}
		
		//Array donde se guardan las zonas
		var zonas:Array<Array<Array<Int>>> = new Array<Array<Array<Int>>>();
		
		//////////Busca componentes biconectados//////////
		var stack:Array<Array<Int>> = new Array<Array<Int>>();
		for (v in 0...verticesBC.length) {
			if (!verticesBC[v].visited) {
				getArticulationPoints(v, 0, verticesBC, stack, zonas);
			}
		}
		
		
		//////////Coloca en el mapa de presión la identidad de cada zona//////////
		var nodoP:Vertice;
		var zona:Int = 1;
		
		//Por cada zona
		for (z in 0...zonas.length) {
			//Por cada vertice
			for (v in zonas[z]) {
				nodoP = vertices[v[0]];
				for (vec in 0...nodoP.vecinos.length) {
					if (nodoP.vecinos[vec] == v[1]) {
						for (a in 0...nodoP.caminoVecinos[vec].length - 1) {
							pressMap[Std.int(nodoP.caminoVecinos[vec][a].y)][Std.int(nodoP.caminoVecinos[vec][a].x)] = zona;
						}
					}
				}
			}
			zona++;
		}
		
		//////////Cuenta el tamaño de cada zona//////////
		var sizeZonas:Array<Int> = new Array<Int>();
		for (i in 0...zonas.length) {
			sizeZonas[i] = 0;
		}
		
		for (y in 0...pressMap.length) {
			for (x in 0...pressMap[y].length) {
				sizeZonas[Std.int(pressMap[y][x]) - 1]++;
			}
		}
		
		//////////Busca el maximo//////////
		var maximo:Int = 0;
		for (i in sizeZonas) {
			if (i > maximo) {
				maximo = i;
			}
		}
		
		//////////Asigna presión en función del tamaño relativo del area//////////
		var grupo:Float;
		for (y in 0...pressMap.length) {
			for (x in 0...pressMap[y].length) {
				grupo = pressMap[y][x];
				if (grupo > 0) {
					pressMap[y][x] = 10 * (1 - (sizeZonas[Std.int(grupo) - 1] / maximo));
				}
			}
		}
		
		trace(pressMap);
		
	}
	
	private function invertirArray(array:Array<FlxPoint>, vertice:Vertice):Array<FlxPoint> {
		var arrayN:Array<FlxPoint> = array.copy();
		arrayN.pop();
		arrayN.reverse();
		arrayN.push(new FlxPoint(vertice.x, vertice.y));
		return arrayN;
	}
	
	private function getArticulationPoints(i:Int, time:Int, verticesBC:Array<VerticeBC>, stack:Array<Array<Int>>, zonas:Array<Array<Array<Int>>>) {
		var u:VerticeBC = verticesBC[i];
		//trace(u.v.x, u.v.y);
		u.visited = true;
		u.st = time + 1;
		u.low = u.st;
		var dfsChild:Int = 0;
		var ni:VerticeBC;
		for (v in 0...u.v.vecinos.length) {
			if (u.v.vecinos[v] != -1) {
				ni = verticesBC[u.v.vecinos[v]];
				if (!ni.visited) {
					stack.push(entradaStck(i,u.v.vecinos[v]));
					ni.parents = i;
					getArticulationPoints(u.v.vecinos[v], u.st, verticesBC, stack, zonas);
					if (ni.low >= u.st) {
						outputComp(stack, entradaStck(i,u.v.vecinos[v]), zonas);
					}
					if (ni.low < u.low) {
						u.low = ni.low;
					}
				} else if ( u.v.vecinos[v] != u.parents && ni.st < u.st) {
					stack.push(entradaStck(i,u.v.vecinos[v]));
					if (ni.st < u.low) {
						u.low = ni.st;
					}
				}
			}
		}
	}
	
	private function entradaStck(u:Int, v:Int):Array<Int> {
		var nodo:Array<Int> = new Array<Int>();
		nodo.push(u);
		nodo.push(v);
		return nodo;
	}
	
	private function outputComp(stack:Array<Array<Int>>, hasta:Array<Int>, zonas:Array<Array<Array<Int>>>) {
		var e:Array<Int>;
		var z:Array<Array<Int>> = new Array<Array<Int>>();
		
		do { 
			e = stack.pop();
			z.push(e);
		} while (!(e[0] == hasta[0] && e[1] == hasta[1]));
		
		zonas.push(z);
	}
	
}

class Vertice
{
	public var vecinos:Array<Int> = new Array<Int>();
	public var caminoVecinos:Array<Array<FlxPoint>> = new Array<Array<FlxPoint>>();
	public var x:Int;
	public var y:Int;
	
	public function new(x:Int, y:Int, up:Int, down:Int, left:Int, right:Int) {
		this.x = x;
		this.y = y;
		vecinos[0] = up;
		vecinos[1] = down;
		vecinos[2] = left;
		vecinos[3] = right;
		
		var camino:Array<FlxPoint>;
		for (i in 0...4) {
			camino = new Array<FlxPoint>();
			camino.push(new FlxPoint(-1,-1));
			caminoVecinos.push(camino);
		}
	}
}

class VerticeBC{
	public var v:Vertice;
	public var visited:Bool = false;
	public var st:Int;
	public var low:Int;
	public var parents:Int = -1;
	
	public function new(vertice:Vertice) {
		this.v = vertice;
	}
}