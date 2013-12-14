package ;

import flash.display.Sprite;

class Helper extends Sprite {

	// use this to ensure any parent issues are resolved when destroying objects
	// source: cristibaluta link: http://haxe.org/doc/snip/saferemove
	public static function safeDestroy (obj:Dynamic, ?destroy:Bool=false) :Bool {
        
        if (obj == null) return false;
        
        var objs :Array<Dynamic> = Std.is (obj, Array) ? obj : [obj];
        
        for (o in objs) {
            if (o == null) continue;
            if (destroy)    try { o.destroy(); }
                            catch (e:Dynamic) { trace("[Error on object: "+o+", {"+e+"}"); }
            
            var parent = null; try { parent = o.parent; } catch (e:Dynamic) { trace(e); }
            if (parent != null) parent.removeChild ( o );
        }
        return true;
    }
	
	// return a random Int between min and max inclusive
	public static function random(min:Int, max:Int):Int {
		return min + Std.random(max - min + 1);
	}
}
