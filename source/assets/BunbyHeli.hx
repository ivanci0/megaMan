package assets;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * ...
 * @author ...
 */
class BunbyHeli extends FlxSprite 
{

	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		makeGraphic(16, 16, FlxColor.ORANGE);
		
	}
	public function Moverse(player:Player):Void{
		if (isOnScreen(FlxG.camera)) 
		{
			
		}
	}
}