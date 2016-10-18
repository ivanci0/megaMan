package;

import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxColor;

class PlayState extends FlxState
{
	var player:FlxSprite;
	var enemigos:FlxTypedGroup<Enemigo> = new FlxTypedGroup<Enemigo>();
	var cantEnemigos:Int = 1;
	var contEnemigos:Int = 0;
	var balasEnemigas:FlxTypedGroup<Bala> = new FlxTypedGroup<Bala>();
	//variables para el lvl
	var ogmoLoader:FlxOgmoLoader;
	var tileMap:FlxTilemap;
	override public function create():Void
	{
		super.create();
		
		//carga del lvl
		ogmoLoader = new FlxOgmoLoader(AssetPaths.lvlPrueba__oel);
		tileMap = ogmoLoader.loadTilemap(AssetPaths.tiles__png, 16, 16, "tiles");
		
		FlxG.worldBounds.set(0, 0, tileMap.width, tileMap.height);
		FlxG.camera.setScrollBounds(0, tileMap.width, 0, tileMap.height);
		
		tileMap.setTileProperties(0, FlxObject.NONE);
		tileMap.setTileProperties(1, FlxObject.NONE);
		tileMap.setTileProperties(2, FlxObject.ANY);
		ogmoLoader.loadEntities(funcionPosicionar, "entities");
		
		player = new FlxSprite(0,0);
		player.makeGraphic(16, 16, FlxColor.BLUE);
		player.acceleration.y = 1000;
		player.health = 100;
		player.maxVelocity.y -= Reg.vSpeed;
		
		FlxG.camera.follow(player);
		
		add(tileMap);
		add(player);
		for (enemigo in enemigos) 
		{
			add(enemigo);
			balasEnemigas.add(enemigo.bala);
		}
		for (bala in balasEnemigas) 
		{
			add(bala);
		}
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		FlxG.collide(tileMap, player);
		coliEnemigoFondo(enemigos);
		colisionEnemigoJugador(enemigos, player);
		colisionJugadorBalas(balasEnemigas, player);
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
	private function funcionPosicionar(entityName:String, entityData:Xml):Void{
		var _x:Int = Std.parseInt(entityData.get("x"));
		var _y:Int = Std.parseInt(entityData.get("y"));
		
		if (entityName == "player") 
		{
			player = new FlxSprite(_x, _y);
		}
		if (entityName == "enemigo1") 
		{
			enemigos.members[contEnemigos] = new Enemigo(_x, _y);
			contEnemigos++;
		}
	}
	//colisiones
	private function coliEnemigoFondo(enemigo:FlxTypedGroup<Enemigo>):Void{
		for (member in enemigo) 
		{
			FlxG.collide(member, tileMap);
		}
	}
	private function colisionEnemigoJugador(enemigo:FlxTypedGroup<Enemigo>,player:FlxSprite):Void{
		for (member in enemigo) 
		{
			if (FlxG.overlap(member,player) )
			{
				player.hurt(10);
				trace(player.health);
			}
		}
	}
	private function colisionJugadorBalas(balas:FlxTypedGroup<Bala>,player:FlxSprite):Void{
		for (bala in balas) 
		{
			if (FlxG.overlap(bala,player)) 
			{
				player.hurt(5);
				bala.kill();
			}
		}
	}
}