package ;
import flixel.FlxObject;

/**
 * ...
 * @author Goldy
 */
class ModuloBlinky implements Modulo
{
	private var fantasma:Fantasma = null;
	private var mapa:Array<Int>;
	
	public function new(mapa:Array<Int>) 
	{
		this.mapa = mapa;
	}
	
	/* INTERFACE Modulo */
	
	public function setFantasma(fantasma:Fantasma):Void 
	{
		this.fantasma = fantasma;
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
		var fx:Int = Math.floor(fantasma.getMidpoint().x / 50);
		
		var up:Bool;
		var down:Bool;
		var left:Bool;
		var right:Bool;
		var caminosLibres:Int = 0;
		
		//TODO: Mejor que 21 directamente
		if (mapa[(fy * 21) + 1 + fx] == 0){ caminosLibres++; right = true;}
		else { right = false;}
		if (mapa[(fy * 21) - 1 + fx] == 0){ caminosLibres++; left = true;}
		else { left = false;}
		if (mapa[((fy + 1) * 21) + fx] == 0) { caminosLibres++; down = true; }
		else { down = false;}
		if (mapa[((fy - 1) * 21) + fx] == 0) { caminosLibres++; up = true; }
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
			}
		}
		
		return FlxObject.NONE;
		
	}
	
	public function movimientoPanico():Void 
	{
		if (fantasma == null) {
			//TODO: return null
		}
	}
	
}