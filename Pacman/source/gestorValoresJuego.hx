package ;

/**
 * ...
 * @author Goldy
 */
class gestorValoresJuego
{
	private var nivel:Int = 0;
	
	private var velocidadBase:Int = 200;
	
	//Dependientes de nivel
	private var pacmanSpeed:Array<Array<Int>> = [
	[1, 2, 5, 21],
	[80, 90, 100, 90]];
	private var frightPacmanSpeed:Array<Array<Int>> = [
	[1, 2, 5],
	[90, 95, 100]];
	private var ghostSpeed:Array<Array<Int>> = [
	[1, 2, 4],
	[75, 85, 95]];
	private var frightGhostSpeed:Array<Array<Int>> = [
	[1, 2, 5],
	[50, 55, 60]];
	private var ghostTunelSpeed:Array<Array<Int>> = [
	[1, 2, 5],
	[40, 45, 50]];
	private var frightTime:Array<Array<Int>> = [
	[1, 2, 3, 4, 5, 6, 7, 9, 10, 11, 12, 14, 15],
	[6, 5, 4, 3, 2, 5, 2, 1, 5, 2, 1, 3, 1]];
	
	public function new() 
	{
	}
	
	public function getForThisLevel(array:Array<Array<Int>>):Int {
		if (array.length < 1) {
			return -1;
		}
		
		var i:Int = 0
		while (array[0].length - 1 > i  || array[0][i] <= nivel) {
			i++;
		}
		return [1][i];
	}
	
	public function getPacmanSpeed():Int {
		return getForThisLevel(pacmanSpeed);
	}
	public function getFrightPacmanSpeed():Int {
		return getForThisLevel(frightPacmanSpeed);
	}
	public function getGhostSpeed():Int {
		return getForThisLevel(ghostSpeed);
	}
	public function getFrightGhostSpeed():Int {
		return getForThisLevel(frightGhostSpeed);
	}
	public function getGhostTunelSpeed():Int {
		return getForThisLevel(ghostTunelSpeed);
	}
	public function getFrightTime():Int {
		return getForThisLevel(frightTime);
	}
}