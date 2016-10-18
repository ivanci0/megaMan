package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxColor;

class PlayState extends FlxState
{
	private var player:FlxSprite;
	private var platform:FlxSprite;
	override public function create():Void
	{
		super.create();
		
		platform = new FlxSprite(0, 300);
		platform.makeGraphic(FlxG.width, 32,FlxColor.BROWN);
		platform.immovable = true;
		
		player = new FlxSprite(200, 100);
		player.makeGraphic(32, 32, FlxColor.BLUE);
		player.acceleration.y = 1000;
		player.maxVelocity.y -= Reg.vSpeed;
		
		FlxG.camera.follow(player);
		
		add(platform);
		add(player);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		FlxG.collide(platform, player);
		Movimiento();
	}
	
	private function Movimiento():Void{
		player.velocity.x = 0;
		
		if (FlxG.keys.pressed.RIGHT) 
		{
			player.velocity.x += Reg.hSpeed;
		}
		if (FlxG.keys.pressed.LEFT) 
		{
			player.velocity.x -= Reg.hSpeed;
		}
		if (FlxG.keys.justPressed.UP && player.isTouching(FlxObject.FLOOR)) 
		{
			player.velocity.y = Reg.vSpeed;
		}
	}
}