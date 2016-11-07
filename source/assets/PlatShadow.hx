package assets;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

/**
 * ...
 * @author Ivan Baigorria
 */
class PlatShadow extends FlxSprite
{
	var timer:FlxTimer;
	var toca:Bool;
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		immovable = true;
		timer = new FlxTimer();
		makeGraphic(48, 16, FlxColor.BROWN);
	}
	override public function update(elapsed:Float):Void 
	{
		if (!toca) 
		{
			tocado();
		}
		super.update(elapsed);
	}
	public function tocado():Void{
		if (isTouching(FlxObject.UP)) 
		{
			toca = true;
			timer.start(3, desaparecer,0);
		}
	}
	public function desaparecer(timer:FlxTimer):Void {
		alive = !alive;
		exists = !exists;
	}
}