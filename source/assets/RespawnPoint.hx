package assets;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author ...
 */
class RespawnPoint extends FlxSprite
{

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		makeGraphic(20, 10);
	}
	public function checkpoint():Void
	{
		Reg.checkpointX = x;
		Reg.checkpointY = y;
	}
	
}