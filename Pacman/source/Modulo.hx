package ;
import flixel.FlxObject;
import flixel.util.FlxPoint;

/**
 * ...
 * @author Goldy
 */
class Modulo
{
	private var fantasma:Fantasma = null;
	private var mapa:Array<Array<Int>>;
	private var color:String = null;
	private var esquina:FlxPoint = new FlxPoint(0, 0);
	
	private var frightened:Bool = false;
	private var scatter:Bool = false;
	
	public function new(mapa:Array<Array<Int>>) 
	{
		this.mapa = mapa;
	}
	
	public function setFantasma(fantasma:Fantasma):Void 
	{
		this.fantasma = fantasma;
	}
	
	public function setEsquina(esquina:FlxPoint):Void
	{
		this.esquina = esquina;
	}
	
	public function getColor():String 
	{
		return null;
	}
	
	public function movimientoRegular():Int
	{
		if (fantasma == null) {
			return FlxObject.NONE;
		}
		
		//Casillas
		var fy:Int = Math.floor(fantasma.getMidpoint().y/50); 
		var fx:Int = Math.floor(fantasma.getMidpoint().x/50);
		
		var up:Bool;
		var down:Bool;
		var left:Bool;
		var right:Bool;
		var caminosLibres:Int = 0;
		
		if (mapa[fy][fx + 1] == 0){ caminosLibres++; right = true;}
		else { right = false;}
		if (mapa[fy][fx - 1] == 0){ caminosLibres++; left = true;}
		else { left = false;}
		if (mapa[fy + 1][fx] == 0) { caminosLibres++; down = true; }
		else { down = false;}
		if (mapa[fy - 1][fx] == 0) { caminosLibres++; up = true; }
		else { up = false; }
		
		if (caminosLibres == 1) {
			if (up) {
				return FlxObject.UP;
			} else if (down) {
				return FlxObject.DOWN;
			} else if (left) {
				return FlxObject.LEFT;
			} else {
				return FlxObject.RIGHT;
			}
		} else {
			var facing:Int = fantasma.facing;
			
			if (caminosLibres == 2) {
				if (up && facing!=FlxObject.DOWN) {
					return FlxObject.UP;
				} else if (down && facing!=FlxObject.UP) {
					return FlxObject.DOWN;
				} else if (left && facing!=FlxObject.RIGHT) {
					return FlxObject.LEFT;
				} else {
					return FlxObject.RIGHT;
				}
			} else if (caminosLibres != 0) {
				if (frightened) {
					return movimientoPanico();
				} else {
					if (scatter) {
						return caminoScatter(facing);
					} else {
						return decidirCamino(facing);
					}
				}
			}
		}
		
		return FlxObject.NONE;
		
	}
	
	private function decidirCamino(facing:Int):Int {
		return FlxObject.NONE;
	}
	
	private function caminoScatter(facing:Int) {
		return FlxObject.NONE;
	}
	
	public function alternarSC():Void
	{
		if (scatter) {
			scatter = false;
		} else {
			scatter = true;
		}
	}
	
	public function setFrightened(asustado:Bool):Void
	{ 
		frightened = asustado;
	}
	
	public function isFrightened():Bool
	{
		return frightened;
	}
	
	private function movimientoPanico():Int
	{	
		//TODO: FY, FX y facing se recalculan
		var fy:Int = Math.floor(fantasma.getMidpoint().y/50); 
		var fx:Int = Math.floor(fantasma.getMidpoint().x / 50);
		var facing:Int = fantasma.facing;
		var disponibles:Array<Int> = new Array<Int>();
		
		if (facing != FlxObject.UP && mapa[fy + 1][fx] == 0) { disponibles.push(FlxObject.DOWN); }
		if (facing != FlxObject.DOWN && mapa[fy - 1][fx] == 0) { disponibles.push(FlxObject.UP); }
		if (facing != FlxObject.LEFT && mapa[fy][fx + 1] == 0) { disponibles.push(FlxObject.RIGHT); }
		if (facing != FlxObject.RIGHT && mapa[fy][fx - 1] == 0) { disponibles.push(FlxObject.LEFT); }
		
		return disponibles[Std.random(disponibles.length)];
	}
}

enum TipoIA {
	Blinky;
	Pinky;
	Inky;
	Clyde;
}