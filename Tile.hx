package ;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.geom.ColorTransform;
import flash.geom.Point;
import flash.geom.Rectangle;
import openfl.Assets;

/**
 * ...
 * @author Jeremiah Goerdt
 */
 
class Tile extends Sprite {
	public static var WIDTH:Int = 20;
	public static var HEIGHT:Int = 20;
	
	// use these to define tile types at creation
    public inline static var BG = 1;
	public inline static var WALL = 2;
	public inline static var PICKUP = 3;
	public inline static var EXIT = 4;
	
	private var id:Int;
	private var image:Bitmap;
	private var colorTransform:ColorTransform;

	public function new(id:Int) {
		super();
		
		// set parameters to variables
		// if a tile is blocked it also blocks sight by default
		this.id = id;
		setImage(id);
		addChild(image);
	}

	public function setImage(id:Int){
		switch(id) {
            case BG:
                image = new Bitmap(Assets.getBitmapData("assets/bg.png"));
			case WALL:
                image = new Bitmap(Assets.getBitmapData("assets/wall.png"));
			case PICKUP: 
                image = new Bitmap(Assets.getBitmapData("assets/pickup.png"));
			case EXIT:
                image = new Bitmap(Assets.getBitmapData("assets/exit.png"));
		}
	}
	
	public function setLoc(x:Float, y:Float) {
		image.x = x * WIDTH;
		image.y = y * HEIGHT;
	}
	
	public function getId():Int{
		return id;
	}

	public function getLoc():Point{
		return new Point(image.x / WIDTH, image.y / HEIGHT);
	}
	
	public function update(){
		//setColor(id);
	}
}
