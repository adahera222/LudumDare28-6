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

	// UI objects
	
	// game objects
    private var bg:Bitmap;
    private var player:Player;
    private var path:Array<Point>;
    private var command:Bitmap;

    // helpers
    private var clicked = false;
	
	public function new() {
		super();
		addEventListener(Event.ENTER_FRAME, update);
        addEventListener(MouseEvent.CLICK, click);

        // mockup background for testing
        bg = new Bitmap(Assets.getBitmapData("assets/bg-mockup.png"));
        addChild(bg);

        player = new Player();
        addChild(player);

        command = new Bitmap(Assets.getBitmapData("assets/click.png"));
        command.x += 50;
        command.y += 400;
        addChild(command);

        path = new Array<Point>();
	}

    private function click(me:MouseEvent){
        if(command.hitTestPoint(Lib.current.stage.mouseX, Lib.current.stage.mouseY)){
            player.startMove(path);
        }
        else {
            path.push(new Point(Lib.current.stage.mouseX, Lib.current.stage.mouseY));
        }
    }
	
	private function update(e:Event) {
        player.update();
	}
	
	public static function main() {
		// static entry point
		Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;

		instance = new Main();
		Lib.current.addChild(instance);
	}
}
