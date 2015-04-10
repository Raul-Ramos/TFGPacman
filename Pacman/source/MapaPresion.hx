package  ;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxPoint;
import flixel.FlxG;

import flixel.util.FlxColor;
import flixel.text.FlxText;
using flixel.util.FlxSpriteUtil;


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
		
		//////////Busca conexiones entre vertices para crear grafo//////////
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
								vertice.vecinos[i] = -3;
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
		
		//////////Asigna presión a los no-vertices en función del tamaño relativo del area//////////
		//Se pone un extra para diferenciar el área de menor presión de los vértices, que se quedan en 0//
		var grupo:Float;
		for (y in 0...pressMap.length) {
			for (x in 0...pressMap[y].length) {
				grupo = pressMap[y][x];
				if (grupo > 0) {
					pressMap[y][x] = 10 * (1 - (sizeZonas[Std.int(grupo) - 1] / maximo)) + 1;
				}
			}
		}

		//////////Asigna presión a los vertices en función de las arestas vecinas//////////
		var lados, sumaLados:Float;
		
		for (verti in vertices) {
			lados = 0;
			sumaLados = 0;
			posX = verti.x;
			
			posY = verti.y + 1;
			if (posY > mapa.length - 1) posY = 0;
			if (pressMap[posY][posX] > 0) {
				lados++;
				sumaLados += pressMap[posY][posX];
			}
			
			posY = verti.y - 1;
			if (posY < 0 ) posY = mapa.length - 1;
			if (pressMap[posY][posX] > 0) {
				lados++;
				sumaLados += pressMap[posY][posX];
			}
			
			posY = verti.y;
			posX = verti.x + 1;
			if (posX > mapa[0].length - 1) posX = 0;
			if (pressMap[posY][posX] > 0) {
				lados++;
				sumaLados += pressMap[posY][posX];
			}
			
			posX = verti.x - 1;
			if (posX < 0 ) posX = mapa[0].length - 1;
			if (pressMap[posY][posX] > 0) {
				lados++;
				sumaLados += pressMap[posY][posX];
			}
			
			pressMap[verti.y][verti.x] = (sumaLados / lados);
			
		}
		
		//////////Presión extra por lejanía con los vertices//////////
		extenderPresion(vertices);
	}
	
	public function getMapa():Array<Array<Float>>
	{
		return pressMap;
	}
	
	//////////Dibuja el mapa en pantalla para debugging	//////////
	public function dibujarMapa(playstate:PlayState, origen:FlxPoint, tamanyoTile:Int, text:Bool = false) {
		
		//////////Busca maximo y minimo//////////
		var maximo:Float = -1;
		var minimo:Float = -1;
		for ( fila in pressMap) {
			for (elemento in fila) {
				if (elemento > maximo) maximo = elemento;
				if (elemento > -1 && (minimo == -1 || elemento < minimo )) minimo = elemento;
			}
		}
		
		//////////Crea el area de dibujo//////////
		var canvas:FlxSprite = new FlxSprite(origen.x, origen.y);
		canvas.makeGraphic(pressMap[0].length * tamanyoTile, pressMap.length * tamanyoTile, FlxColor.TRANSPARENT, true);
		playstate.add(canvas);
		
		
		var color, G, R:Int;
		var media:Float = (maximo - minimo) / 2;
		
		for (fila in 0...pressMap.length) {
			for (elemento in 0...pressMap[fila].length) {
				if (pressMap[fila][elemento] > -1) {
					//Degradado
					//Si está por encima de la media, va de G 255 -> 0 y R 255 (Amarillo -> Rojo)
					//Si está por debajo de la media, va de R 0 -> 255 y G 255 (Verde -> Amarillo)
					if (pressMap[fila][elemento] >= media) {
						G = Std.int(255 * (1 - ((pressMap[fila][elemento] - media) / (maximo - media))));
						R = 255;
					} else {
						G = 255;
						R = Std.int(255 * ((pressMap[fila][elemento] - minimo) / (media - minimo)));
					}
					
					//Pinta el cuadrado
					color = (255 & 0xFF) << 24 | (R & 0xFF) << 16 | (G & 0xFF) << 8 | (0 & 0xFF);
					canvas.drawRect(elemento * tamanyoTile, fila * tamanyoTile, tamanyoTile, tamanyoTile, color);
					
					//Añade texto si se ha especificado
					if(text){
						var myText:FlxText = new FlxText(elemento * tamanyoTile, fila * tamanyoTile, tamanyoTile);
						myText.text = Std.string(floatToStringPrecision(pressMap[fila][elemento],3));
						myText.setFormat(20, FlxColor.GREEN, "center");
						playstate.add(myText);
					}
				}
			}
		}
	}
	
	//////////Devuelve el string con unos digitos especificos//////////
	private function floatToStringPrecision(n:Float, prec:Int){
	  n = Math.round(n * Math.pow(10, prec));
	  var str = ''+n;
	  var len = str.length;
	  if(len <= prec){
		while(len < prec){
		  str = '0'+str;
		  len++;
		}
		return '0.'+str;
	  }
	  else{
		return str.substr(0, str.length-prec) + '.'+str.substr(str.length-prec);
	  }
	}
	
	//////////Asigna presión adicional a las casillas en proporcion a la lejanía con un vertice//////////
	private function extenderPresion(vertices:Array<Vertice>) {
		var nodosAbiertos:Array<NodoExtension> = new Array<NodoExtension>();
		var nodosCerrados:Array<NodoExtension> = new Array<NodoExtension>();
		
		//Abre los nodos iniciales a partir de los vertices
		var x, y:Int;
		for (v in vertices) {
			for (ve in 0...v.vecinos.length) {
				x = v.x;
				y = v.y;
				switch(ve) {
					case 0:
						y -= 1;
						if (y < 0) y = pressMap.length - 1;
					case 1:
						y += 1;
						if (y > pressMap.length - 1) y = 0;
					case 2:
						x -= 1;
						if (x < 0) x = pressMap[0].length - 1;
					default:
						x += 1;
						if (x > pressMap[0].length - 1) x = 0;
				}
				
				//Si son caminos sin salida, penalizacion extra
				if (v.vecinos[ve] == -3) {
					nodosAbiertos.push(new NodoExtension(new FlxPoint(x, y), (pressMap[v.y][v.x] + 2) * 2));
				}
				else if (v.vecinos[ve] != -1) {
					nodosAbiertos.push(new NodoExtension(new FlxPoint(x, y), pressMap[v.y][v.x]));
				}
			}
			
			pressMap[v.y][v.x] *= 1.5;
			nodosCerrados.push(new NodoExtension(new FlxPoint(v.x, v.y), 0));
		}
		
		var xor, yor, num:Int;
		var nodo:NodoExtension;
		
		while (nodosAbiertos.length > 0) {
			num = nodosAbiertos.length;
			for (nodoI in 0...num) {
				nodo = nodosAbiertos[nodoI];
				
				xor = Std.int(nodo.posicion.x);
				yor = Std.int(nodo.posicion.y);
				
				//Se añade el valor acumulado extra
				pressMap[yor][xor] += nodo.valorAcumulado;
				
				x = xor;
				y = yor + 1;
				if (y > pressMap.length - 1) y = 0;
				if (pressMap[y][x] > -1 && !contiene(x, y, nodosAbiertos) && !contiene(x, y, nodosCerrados)) {
					nodosAbiertos.push(new NodoExtension(new FlxPoint(x, y), nodo.valorAcumulado + 2));
				}
				
				y = yor - 1;
				if (y < 0) y = pressMap.length - 1;
				if (pressMap[y][x] > -1 && !contiene(x, y, nodosAbiertos) && !contiene(x, y, nodosCerrados)) {
					nodosAbiertos.push(new NodoExtension(new FlxPoint(x, y), nodo.valorAcumulado + 2));
				}
				
				x = xor + 1;
				y = yor;
				if (x > pressMap[0].length - 1) x = 0;
				if (pressMap[y][x] > -1 && !contiene(x, y, nodosAbiertos) && !contiene(x, y, nodosCerrados)) {
					nodosAbiertos.push(new NodoExtension(new FlxPoint(x, y), nodo.valorAcumulado + 2));
				}
				
				x = xor - 1;
				if (x < 0) x = pressMap[0].length - 1;
				if (pressMap[y][x] > -1 && !contiene(x, y, nodosAbiertos) && !contiene(x, y, nodosCerrados)) {
					nodosAbiertos.push(new NodoExtension(new FlxPoint(x, y), nodo.valorAcumulado + 2));
				}
				
				nodosCerrados.push(nodo);
			}
			
			nodosAbiertos.splice(0, num);
		}
	}
	
	private function contiene(x:Float, y:Float, array:Array<NodoExtension>):Bool {
		for (n in array) {
			if (n.posicion.x == x && n.posicion.y == y) {
				return true;
			}	
		}
		return false;
	}
	
	//////////Duplica, invierte y retorna una array de flxpoint//////////
	private function invertirArray(array:Array<FlxPoint>, vertice:Vertice):Array<FlxPoint> {
		var arrayN:Array<FlxPoint> = array.copy();
		arrayN.pop();
		arrayN.reverse();
		arrayN.push(new FlxPoint(vertice.x, vertice.y));
		return arrayN;
	}
	
	//////////Busca los componentes biconectados//////////
	private function getArticulationPoints(i:Int, time:Int, verticesBC:Array<VerticeBC>, stack:Array<Array<Int>>, zonas:Array<Array<Array<Int>>>) {
		var u:VerticeBC = verticesBC[i];
		u.visited = true;
		u.st = time + 1;
		u.low = u.st;
		var dfsChild:Int = 0;
		var ni:VerticeBC;
		for (v in 0...u.v.vecinos.length) {
			if (u.v.vecinos[v] > -1) {
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
	
	//////////Crea un elemento del stack de la búsqueda de componentes biconectados//////////
	private function entradaStck(u:Int, v:Int):Array<Int> {
		var nodo:Array<Int> = new Array<Int>();
		nodo.push(u);
		nodo.push(v);
		return nodo;
	}
	
	//////////Crea una zona nueva con las frontas de los componentes biconectados//////////
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

//////////Vertice que contiene los vecinos, los puntos intermedios y la posición//////////
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

//////////Vertice que contiene un Vertice regular y datos para la búsqueda de componentes biconectados//////////
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

class NodoExtension {
	public var posicion:FlxPoint;
	public var valorAcumulado:Float;
	
	public function new(posicion:FlxPoint, valor:Float) {
		this.posicion = posicion;
		this.valorAcumulado = valor;
	}
}