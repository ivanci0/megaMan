package assets;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;
import flixel.util.FlxColor;

/**
 * ...
 * @author Yo xD!!1!11!!!!
 */
class Player extends FlxSprite
{

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		makeGraphic(50, 100, FlxColor.WHITE);
		acceleration.y = 1000;
		maxVelocity.y -= Reg.vSpeed;
		
	}
	public function MoveRight():Void{
			velocity.x = Reg.hSpeed;
	}
	public function MoveLeft():Void{
			velocity.x = -1 * Reg.hSpeed;
	}
	public function Jump():Void{
			velocity.y = Reg.vSpeed;
	}
}