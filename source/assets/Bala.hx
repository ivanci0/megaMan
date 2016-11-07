package assets;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * ...
 * @author Ivan Baigorria
 */
class Bala extends FlxSprite
{
	var velocidad:Float;
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		makeGraphic(4, 2, FlxColor.MAGENTA);
		velocidad = 100;
	}
	override public function update(elapsed:Float):Void 
	{
		detectarColision();
		super.update(elapsed);
	}
	public function salirDisparada(ang:Float):Void{
		velocity.set(velocidad);
		velocity.rotate(FlxPoint.weak(0, 0), ang);
	}
	private function detectarColision():Void{
		if (x < FlxG.camera.scroll.x || x > FlxG.camera.scroll.x + FlxG.camera.width || y < FlxG.camera.scroll.y || y > FlxG.camera.scroll.y + FlxG.camera.height) 
		{
			kill();
			trace("muelta");
		}
	}
}