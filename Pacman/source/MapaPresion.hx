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
		
		for (i in 0...vertices.length) {
			trace(i, vertices[i].x, vertices[i].y, vertices[i].vecinos.toString());
		}
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