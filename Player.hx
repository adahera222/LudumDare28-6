package ;

import flash.geom.Point;
import flash.display.Bitmap;
import flash.display.Sprite;
import openfl.Assets;
import motion.Actuate;
import motion.easing.Linear;
import flash.geom.Vector3D;

class Player extends Sprite{

    private var img:Bitmap;
    private var center:Point;
    private var isMoving = false;
    private var speed = 100;
    private var destination:Point;
    private var path:Array<Point>;

    public function new(){
        super();

        img = new Bitmap(Assets.getBitmapData("assets/player.png"));
        addChild(img);

        center = new Point(img.width / 2, img.height / 2);
    }

    private function changeDestination(){
		var centerVec = new Vector3D(center.x, center.y, 0);
		destination = path.pop();
		var destinationVec = new Vector3D(destination.x, destination.y, 0);
		var tmp = Vector3D.distance(centerVec, destinationVec);
		Actuate.tween(center, tmp / speed, {x:destination.x, y:destination.y}).ease(Linear.easeNone);
    }

    public function startMove(path:Array<Point>){
        path.reverse();
        this.path = path;
		isMoving = true;
        changeDestination();
    }

    private function move(){
		img.x = center.x - img.width / 2;
		img.y = center.y - img.height / 2;
		if (path.length > 0 && center.x == destination.x && center.y == destination.y) {
            changeDestination();
		} else if(center.x == destination.x && center.y == destination.y){
            isMoving = false;
        }
    }

    public function update(){
        if(isMoving) move();
    }
}
