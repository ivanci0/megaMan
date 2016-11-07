package assets;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

/**
 * ...
 * @author Ivan Baigorria
 */
class Barro extends FlxSprite
{
	var elTimer:FlxTimer;
	var toca:Bool;
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		elTimer = new FlxTimer();
		immovable = true;
		makeGraphic(16, 16, FlxColor.PURPLE);
	}
	override public function update(elapsed:Float):Void 
	{
		if (!toca) 
		{
			tocado();
		}
		muere();
		super.update(elapsed);
	}
	public function tocado():Void{
		if (isTouching(FlxObject.UP)) 
		{
			toca = true;
			elTimer.start(0.33, caerse);
		}
	}
	public function caerse(elTimer:FlxTimer):Void{
		velocity.y = 300;
	}
	public function muere():Void{
		if (y >= FlxG.height) 
		{
			kill();
		}
	}
}