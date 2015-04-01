package  ;
import flixel.FlxObject;

/**
 * ...
 * @author Goldy
 */
class MapaPresion
{
	public function new(mapa:Array<Array<Int>>) 
	{
		var vertices:Array<Vertice> = new Array<Vertice>();
		var up, down, left, right,cantidad:Int;
		
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
		
		for (v in 0...vertices.length) {
			var vertice:Vertice = vertices[v];
			for (i in 0...vertice.vecinos.length) {
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
							}
						}
						//Si se ha encontrado
						else {
							vertice.vecinos[i] = found;
							switch (from) {
								case FlxObject.UP:
									vertices[found].vecinos[0] = v;
								case FlxObject.DOWN:
									vertices[found].vecinos[1] = v;
								case FlxObject.LEFT:
									vertices[found].vecinos[2] = v;
								default:
									vertices[found].vecinos[3] = v;
							}
						}
					}
				}
			}
		}
		
		var time:Int = 0;
		var verticesBC:Array<VerticeBC> = new Array<VerticeBC>();
		for (v in 0...vertices.length) {
			verticesBC.push(new VerticeBC(vertices[v]));
		}
		
		var stack:Array<String> = new Array<String>();
		for (v in 0...verticesBC.length) {
			if (!verticesBC[v].visited) {
				getArticulationPoints(v, 0, verticesBC, stack);
			}
		}
	}
	
	private function getArticulationPoints(i:Int, time:Int, verticesBC:Array<VerticeBC>, stack:Array<String>) {
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
					stack.push(entradaStck(u,ni));
					ni.parents = i;
					getArticulationPoints(u.v.vecinos[v], u.st, verticesBC, stack);
					if (ni.low >= u.st) {
						outputComp(stack, entradaStck(u,ni));
					}
					if (ni.low < u.low) {
						u.low = ni.low;
					}
				} else if ( u.v.vecinos[v] != u.parents && ni.st < u.st) {
					stack.push(entradaStck(u,ni));
					if (ni.st < u.low) {
						u.low = ni.st;
					}
				}
			}
		}
	}
	
	private function entradaStck(u:VerticeBC, v:VerticeBC):String {
		return Std.string(u.v.x) + "," + Std.string(u.v.y) + " - " + Std.string(v.v.x) + "," + Std.string(v.v.y);
	}
	
	private function outputComp(stack:Array<String>, hasta:String) {
		trace("Encontrado nuevo componente biconectado");
		var e:String;
		do { 
			e = stack.pop();
			trace(e);
		} while (e != hasta);
	}
	
}

class Vertice
{
	public var vecinos:Array<Int> = new Array<Int>();
	public var x:Int;
	public var y:Int;
	
	public function new(x:Int, y:Int, up:Int, down:Int, left:Int, right:Int) {
		this.x = x;
		this.y = y;
		vecinos[0] = up;
		vecinos[1] = down;
		vecinos[2] = left;
		vecinos[3] = right;
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