package ;

import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.util.FlxAngle;

/**
 * ...
 * @author Goldy
 */
class Pacman extends FlxSprite
{
	private var upCommand:Bool = false;
	private var downCommand:Bool = false;
	private var leftCommand:Bool = false;
	private var rightCommand:Bool = false;
	
	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		
		maxVelocity.x = 200;
		
		loadGraphic(AssetPaths.pacmanO__png, true, 50, 50);
		
		setFacingFlip(FlxObject.LEFT, false, false);
		setFacingFlip(FlxObject.RIGHT, true, false);
		setFacingFlip(FlxObject.UP, false, false);
		setFacingFlip(FlxObject.DOWN, false, false);
		
		setSize(46, 46); //39,39 en realidad
		//offset.set(4, 6);
		
	}
	
	override public function update():Void
    {
        super.update();
		
		orderMovement();
		move();
	}
	
	private function orderMovement():Void
	{
		var _up:Bool = false;
		var _down:Bool = false;
		var _left:Bool = false;
		var _right:Bool = false;
		
		_up = FlxG.keys.anyPressed(["UP", "W"]);
		_down = FlxG.keys.anyPressed(["DOWN", "S"]);
		_left = FlxG.keys.anyPressed(["LEFT", "A"]);
		_right = FlxG.keys.anyPressed(["RIGHT", "D"]);
		
		var sum:Int = 0;
		if (_up) sum++;
		if (_down) sum++;
		if (_left) sum++;
		if (_right) sum++;
		
		if (sum == 1) {
			upCommand = if (_up) true else false;
			downCommand = if (_down) true else false;
			leftCommand = if (_left) true else false;
			rightCommand = if (_right) true else false;
		}
	}
	
	private function move():Void {
		if ((upCommand || downCommand || leftCommand || rightCommand) &&
		this.getMidpoint().x % 50 >= 23 && this.getMidpoint().x % 50 <= 27
		&& this.getMidpoint().y % 50 >= 23 && this.getMidpoint().y % 50 <= 27 ) {
				
			var nowx:Int = Std.int(this.getMidpoint().x / 50); 
			var nowy:Int = Std.int(this.getMidpoint().y / 50);
			
			if (upCommand) {
				if (cast(FlxG.state, PlayState)._mWalls.getData()[((nowy - 1) * cast(FlxG.state, PlayState)._mWalls.widthInTiles) + nowx] == 0) {
					upCommand = false;
					this.velocity.x = 0;
					this.velocity.y = -maxVelocity.x;
					facing = FlxObject.UP;
					angle = 90;
				}
			} else if (downCommand) {
				if (cast(FlxG.state, PlayState)._mWalls.getData()[((nowy + 1) * cast(FlxG.state, PlayState)._mWalls.widthInTiles) + nowx] == 0) {
					downCommand = false;
					this.velocity.x = 0;
					this.velocity.y = maxVelocity.x;
					facing = FlxObject.DOWN;
					angle = -90;
				}
			} else if (rightCommand) {
				if (cast(FlxG.state, PlayState)._mWalls.getData()[(nowy * cast(FlxG.state, PlayState)._mWalls.widthInTiles) + (nowx + 1)] == 0) {
					rightCommand = false;
					this.velocity.x = maxVelocity.x;
					this.velocity.y = 0;
					facing = FlxObject.RIGHT;
					angle = 0;
				}	
			} else {
				if (cast(FlxG.state, PlayState)._mWalls.getData()[(nowy * cast(FlxG.state, PlayState)._mWalls.widthInTiles) + (nowx - 1)] == 0) {
					leftCommand = false;
					this.velocity.x = -maxVelocity.x;
					this.velocity.y = 0;
					facing = FlxObject.LEFT;
					angle = 0;
				}
			}
		}
	}
}