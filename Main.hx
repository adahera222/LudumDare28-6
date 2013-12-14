package ;

import flash.display.Bitmap;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.display.Sprite;
import flash.geom.Point;
import flash.Lib;
import openfl.Assets;

/**
 * ...
 * @author Jeremiah Goerdt aka CaptainKraft
 */

class Main extends Sprite {
	
	// global constants
    public static var instance:Main;
    public static var WIDTH = 800 / 20;
    public static var HEIGHT = 800 / 20;

	// UI objects
	
	// game objects
    private var bg:Bitmap;
    private var level:Level;
    private var player:Player;
    private var path:Array<Point>;
    private var command:Bitmap;
    private var highlight:Bitmap;
    public var highlighted:Bitmap;
    public var score:Int;

    // helpers
	
	public function new() {
		super();
		addEventListener(Event.ENTER_FRAME, update);
        addEventListener(MouseEvent.CLICK, click);

        // mockup background for testing
        bg = new Bitmap(Assets.getBitmapData("assets/bg.png"));
        addChild(bg);

        level = new Level(1);
        addChild(level);

        highlight = new Bitmap(Assets.getBitmapData("assets/highlight.png"));
        addChild(highlight);

        player = new Player();
        addChild(player);
        score = 0;

        command = new Bitmap(Assets.getBitmapData("assets/click.png"));
        command.x += 50;
        command.y += 400;
        addChild(command);

        path = new Array<Point>();
	}

    private function click(me:MouseEvent){
        // figure out which tile the mouse is covering
        var x = Lib.current.stage.mouseX;
        var y = Lib.current.stage.mouseY;
        var xLoc = Math.floor(x / Tile.WIDTH);
        var yLoc = Math.floor(y / Tile.HEIGHT);

        if(command.hitTestPoint(x, y)){
            player.startMove(path);
        }
        else if(path.length > 0){
            if(xLoc == path[path.length - 1].x || yLoc == path[path.length - 1].y){
                path.push(new Point(xLoc, yLoc));
                highlighted = new Bitmap(Assets.getBitmapData("assets/highlight.png"));
                highlighted.x = Math.floor(Lib.current.stage.mouseX / Tile.WIDTH) * Tile.WIDTH;
                highlighted.y = Math.floor(Lib.current.stage.mouseY / Tile.HEIGHT) * Tile.HEIGHT;
                addChild(highlighted);
            }
        }
        else if(xLoc == player.getLoc().x || yLoc == player.getLoc().y) {
            path.push(new Point(xLoc, yLoc));
            highlighted = new Bitmap(Assets.getBitmapData("assets/highlight.png"));
            highlighted.x = Math.floor(Lib.current.stage.mouseX / Tile.WIDTH) * Tile.WIDTH;
            highlighted.y = Math.floor(Lib.current.stage.mouseY / Tile.HEIGHT) * Tile.HEIGHT;
            addChild(highlighted);
        }
    }
	
	private function update(e:Event) {
        player.update();

        // highlight valid moves
        var x = Lib.current.stage.mouseX;
        var y = Lib.current.stage.mouseY;
        var xLoc = Math.floor(x / Tile.WIDTH);
        var yLoc = Math.floor(y / Tile.HEIGHT);
        highlight.x = Math.floor(Lib.current.stage.mouseX / Tile.WIDTH) * Tile.WIDTH;
        highlight.y = Math.floor(Lib.current.stage.mouseY / Tile.HEIGHT) * Tile.HEIGHT;
        if(path.length > 0){
            if(xLoc == path[path.length - 1].x || yLoc == path[path.length - 1].y){
                highlight.visible = true;
            } 
            else highlight.visible = false;
        }
        else if(xLoc == player.getLoc().x || yLoc == player.getLoc().y) {
            highlight.visible = true;
        } 
        else highlight.visible = false;
	}
	
	public static function main() {
		// static entry point
		Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;

		instance = new Main();
		Lib.current.addChild(instance);
	}
}
