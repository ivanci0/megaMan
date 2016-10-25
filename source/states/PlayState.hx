package states;

import assets.Bala;
import assets.Enemigo;
import assets.Player;
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
	var pastito:FlxSprite;
	var player:Player;
	var enemigos:FlxTypedGroup<assets.Enemigo> = new FlxTypedGroup<assets.Enemigo>();
	var cantEnemigos:Int = 1;
	var contEnemigos:Int = 0;
	var balasEnemigas:FlxTypedGroup<assets.Bala> = new FlxTypedGroup<assets.Bala>();
	//variables para el lvl
	var ogmoLoader:FlxOgmoLoader;
	var tileMap:FlxTilemap;
	
	override public function create():Void
	{
		super.create();
		
		//Pastito try
		pastito = new FlxSprite(0, 0);
		pastito.loadGraphic(AssetPaths.pastito__png, false);
		
		//carga del lvl
		ogmoLoader = new FlxOgmoLoader(AssetPaths.lvlPrueba__oel);
		tileMap = ogmoLoader.loadTilemap(AssetPaths.tiles__png, 16, 16, "tiles");
		
		FlxG.worldBounds.set(0, 0, tileMap.width, tileMap.height);
		FlxG.camera.setScrollBounds(0, tileMap.width, 0, tileMap.height);
		tileMap.setTileProperties(0, FlxObject.NONE);
		tileMap.setTileProperties(1, FlxObject.NONE);
		tileMap.setTileProperties(2, FlxObject.ANY);
		ogmoLoader.loadEntities(funcionPosicionar, "entities");
		
		FlxG.camera.follow(player);
		
		add(tileMap);
		add(player);
		add(pastito);
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
		FlxG.collide(tileMap,player);
		coliEnemigoFondo(enemigos);
		colisionEnemigoJugador(enemigos, player);
		colisionJugadorBalas(balasEnemigas, player);
		Movimiento();
	}
	
	private function Movimiento():Void{
		player.velocity.x = 0;
		
		if (FlxG.keys.pressed.RIGHT && player.x<1024-player.width) 
		{
			player.MoveRight();
			pastito.x--;
		}
		if (FlxG.keys.pressed.LEFT && player.x > 0) 
		{
			player.MoveLeft();
			pastito.x++;
		}
		if (FlxG.keys.justPressed.UP && player.isTouching(FlxObject.FLOOR)) 
		{
			player.Jump();
		}
	}
	private function funcionPosicionar(entityName:String, entityData:Xml):Void{
		var _x:Int = Std.parseInt(entityData.get("x"));
		var _y:Int = Std.parseInt(entityData.get("y"));
		
		if (entityName == "player") 
		{
			player = new Player(0, 0);
		}
		if (entityName == "enemigo1") 
		{
			enemigos.members[contEnemigos] = new assets.Enemigo(_x, _y);
			contEnemigos++;
		}
	}
	//colisiones
	private function coliEnemigoFondo(enemigo:FlxTypedGroup<assets.Enemigo>):Void{
		for (member in enemigo) 
		{
			FlxG.collide(member, tileMap);
		}
	}
	private function colisionEnemigoJugador(enemigo:FlxTypedGroup<assets.Enemigo>,player:FlxSprite):Void{
		for (member in enemigo) 
		{
			if (FlxG.overlap(member,player) )
			{
				player.hurt(10);
				trace(player.health);
			}
		}
	}
	private function colisionJugadorBalas(balas:FlxTypedGroup<assets.Bala>,player:FlxSprite):Void{
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