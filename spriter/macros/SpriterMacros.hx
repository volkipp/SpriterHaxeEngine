package spriter.macros;
import haxe.macro.Expr;

/**
 * ...
 * @author Loudo
 */
class SpriterMacros
{
	/**
	 * Check texture packer atlas to add .png at the end of files.
	 * Because Spriter's SCML use file name with .png at the end and Texture Packer not.
	 * So it will correct this for you.
	 * Data format : Sparrow, Starling only
	 * @param	pathToXml
	 * @return  pathToXml
	 */
	macro public static function texturePackerChecker(pathToXml:Expr) : Expr 
	{
		var xml_path:String = '';
		switch(pathToXml.expr){
			case EConst(c): switch(c){
				case CString(s): xml_path = s; 
				default:{}
			}
			default:{}
		}
		trace('checking texture packer file : '+xml_path);
		var xml_s = sys.io.File.getContent(xml_path);
		var xml = Xml.parse(xml_s);
		var save:Bool = parseTexturePacker(xml.firstElement());
		if(save)
			sys.io.File.saveContent(xml_path, xml.toString());
		
		return pathToXml;
	}
	static function parseTexturePacker(xml:Xml):Bool
	{
		var path:String;
		var corrected:Bool = false;
		for (el in xml.elements())
		{
			if (el.nodeName == 'SubTexture') {
				path = el.get('name');
				if (path.indexOf('.png') == -1) {
					el.set('name', path + '.png');
					corrected = true;
				}else {
					trace('texturePacker XML is ok. No change.');
					break;
				}
			}else {
				trace('texturePacker XML not supported.');
				break;
			}
		}
		if (corrected)
			trace('texturePacker XML is corrected.');
		return corrected;
	}
	/**
	 * Macro to create an animation with image ordering starting with offset number. Not very useful since Spriter b8.
	 * @example SpriterMacros.createSpriterTimeline('assets/test.scml', 35, 0, 'folder/subfolder', 'myImage_', 200, 100, 24);
	 * will create an scml with 35 images at 24 fps like these data :
	 * <file id="0" name="folder/subfolder/myImage_0.png" width="200" height="100" pivot_x="0" pivot_y="1"/>
	 * <key id="0" time="0">
     *      <object_ref id="0" timeline="0" key="0" z_index="0"/>
     * </key>
	 * etc.
	 * 
	 * @param	pathToXml where the .scml file is
	 * @param	frames number of total key frames
	 * @param	offset if your image name doesn't start with 0
	 * @param	folder the folder name
	 * @param	filePrefix the file prefix (before the number)
	 * @param	width of image
	 * @param	height of image
	 * @param	framerate of the animation
	 * @return  pathToXml
	 */
	macro public static function createSpriterTimeline(pathToXml:Expr, frames:Expr, offset:Expr, folder:Expr, filePrefix:Expr, width:Expr, height:Expr, framerate:Expr):Expr
	{
		var xml_path:String = '';
		var frames_num:Int = 0;
		var offset_num:Int = 0;
		var file_prefix:String = '';
		var _folder:String = '';
		var _width:Int = 0;
		var _height:Int = 0;
		var _framerate:Int = 24;
		switch(pathToXml.expr){
			case EConst(c): switch(c){
				case CString(s): xml_path = s; 
				default:{}
			}
			default:{}
		}
		switch(folder.expr){
			case EConst(c): switch(c){
				case CString(s): _folder = s; 
				default:{}
			}
			default:{}
		}
		switch(filePrefix.expr){
			case EConst(c): switch(c){
				case CString(s): file_prefix = s; 
				default:{}
			}
			default:{}
		}
		switch(frames.expr){
			case EConst(c): switch(c){
				case CInt(s): 
					frames_num = Std.parseInt(s); 
				default:{}
			}
			default:{}
		}
		switch(framerate.expr){
			case EConst(c): switch(c){
				case CInt(s): _framerate = Std.parseInt(s); 
				default:{}
			}
			default:{}
		}
		switch(offset.expr){
			case EConst(c): switch(c){
				case CInt(s): offset_num = Std.parseInt(s); 
				default:{}
			}
			default:{}
		}
		switch(width.expr){
			case EConst(c): switch(c){
				case CInt(s): _width = Std.parseInt(s); 
				default:{}
			}
			default:{}
		}
		switch(height.expr){
			case EConst(c): switch(c){
				case CInt(s): _height = Std.parseInt(s); 
				default:{}
			}
			default:{}
		}
		trace('creating timeline file : '+xml_path);
		var xml:Xml = createSCML(_folder, frames_num, offset_num, _framerate, file_prefix, _width, _height);
		sys.io.File.saveContent(xml_path, xml.toString());
		
		return pathToXml;
	}
	static function createSCML(folder:String, frames:Int, offset:Int, framerate:Int, filePrefix:String, _width:Int, _height:Int ):Xml
	{
		var tag:String;
		var done:Bool = false;
		var totalTime:Int = Std.int((frames / framerate) * 1000);
		var stepTime:Int =  Std.int(1000 / framerate);
		var xml_s:String = '<?xml version="1.0" encoding="UTF-8"?>\n'+
		'<spriter_data scml_version="1.0" generator="SpriterHaxeEngine" generator_version="b7">\n'+
		'	<folder id="0" name="'+folder+'">\n'+
		'	</folder>\n'+
		'	<entity id="0" name="entity_000">\n'+
		'		<animation id="0" name="NewAnimation" length="'+totalTime+'">\n'+
		'			<mainline>\n'+
		'			</mainline>\n'+
		'			<timeline id="0" name="'+filePrefix+'">\n'+
		'			</timeline>\n'+
		'		</animation>\n'+
		'	</entity>\n'+
		'</spriter_data>\n';
		
		var xml:Xml = Xml.parse(xml_s).firstElement();
		for (el in xml.elements())
		{
			if (el.nodeName == 'folder') {
				for (i in 0...(frames+1))
				{
					tag = '		<file id="' + i + '" name="' + folder + '/' + filePrefix + (i+offset) + '.png" width="' + _width + '" height="' + _height + '" pivot_x="0" pivot_y="1"/>\n';
					el.addChild(Xml.parse(tag));
				}
			}else if (el.nodeName == 'entity') {
				var ent:Xml = el.firstElement();
				if (ent.nodeName == 'animation') {
					for (anim in ent.elements())
					{
						if (anim.nodeName == 'mainline') {
							for (i in 0...(frames+1))
							{	
								tag = 
								'	<key id="'+i+'" time="'+i*stepTime+'">\n'+
								'		<object_ref id="'+i+'" timeline="0" key="'+i+'" z_index="0"/>\n'+
								'	</key>\n';
								anim.addChild(Xml.parse(tag));
							}
						}else if (anim.nodeName == 'timeline') {
							for (i in 0...(frames+1))
							{	
								tag = 
								'	<key id="'+i+'" time="'+i*stepTime+'" spin="0" >\n'+
								'		<object folder="0" file="'+i+'"/>\n'+
								'	</key>\n';
								anim.addChild(Xml.parse(tag));
							}
						}
					}
				}
			}
		}
		return xml;
	}
	macro public static function createGraal(pathToXml:Expr):Expr
	{
		var xml_path:String = "";
		switch(pathToXml.expr){
			case EConst(c): switch(c){
				case CString(s): xml_path = s; 
				default:{}
			}
			default:{}
		}
		
		var xml:Xml = createGraalXML();
		sys.io.File.saveContent(xml_path, xml.toString());
		
		return pathToXml;
	}
	static function createGraalXML():Xml
	{
		var character:String = "knight";
		var perso:String = "chevalier_";
		var people:String = "briton";
		var peuple:String = "BRETON_";
		
		var width:Int = 480;
		var height:Int = 360;
		var fps:Int = 24;
		var k:Int = 0;
		var animations:Array<{name:String, frames:Int, offset:Int}> = 
		[
			{name:"walk", frames:26, offset:1316},
			{name:"idle", frames:20, offset:0},
			{name:"sword", frames:36, offset:214},
		];
		var tag:String;
		var stepTime:Int =  Std.int(1000 / fps);
		//var totalTime:Int = Std.int((frames / fps) * 1000);
		var xml_s:String = '<?xml version="1.0" encoding="UTF-8"?>\n'+
		'<spriter_data scml_version="1.0" generator="SpriterHaxeEngine" generator_version="b7">\n'+
		'	<entity id="0" name="left">\n'+
		'	</entity>\n' +
		'	<entity id="1" name="right">\n'+
		'	</entity>\n' +
		'	<entity id="2" name="back">\n'+
		'	</entity>\n' +
		'	<entity id="3" name="front">\n'+
		'	</entity>\n'+
		'</spriter_data>\n';
		
		var folder:Xml;
		var f:Int = 0;
		var animationXML:Xml;
		
		var xml:Xml = Xml.parse(xml_s).firstElement();
		for (el in xml.elements())
		{
			if (el.nodeName == "entity") {
				k = 0;
				var direction:String = el.get("name");
				for (l in 0...animations.length) {
					var anim: { name:String, frames:Int, offset:Int } = animations[l];
					//folder
					
					tag = 	'	<folder id="'+f+'" name="'+anim.name + '/' + character + '/' + people+ '/' + direction+'">\n'+
							'	</folder>\n';
					folder = Xml.parse(tag).firstElement();
					xml.addChild(folder);
					f++;
					
					//animation
					tag = '		<animation id="'+l+'" name="'+anim.name+'" length="'+Std.int((anim.frames / fps) * 1000)+'">\n'+
						'			<mainline>\n'+
						'			</mainline>\n'+
						'			<timeline id="0" name="'+anim.name+'">\n'+
						'			</timeline>\n'+
						'		</animation>\n';
					animationXML = Xml.parse(tag).firstElement();
					el.addChild(animationXML);
					var mainline:Xml = animationXML.firstElement();
					var timeline:Xml = animationXML.elementsNamed("timeline").next();
					var m:Int = 0;
					for (i in 0...anim.frames)
					{
						if (i % 2 == 0) {
							//folder
							var fileNum:String = (i + anim.offset) < 10 ? "0"+(i + anim.offset) : ""+(i + anim.offset);
							tag = '	<file id="' + m + '" name="' + anim.name + '/' + character + '/' + people + '/' + peuple + perso + direction +"_"+ fileNum + '.png" width="' + width + '" height="' + height + '" pivot_x="0" pivot_y="1"/>\n';
							folder.addChild(Xml.parse(tag));
							//mainline
							tag = '	<key id="'+m+'" time="'+i*stepTime+'">\n'+
							'		<object_ref id="0" timeline="0" key="'+m+'" z_index="0"/>\n'+
							'	</key>\n';
							mainline.addChild(Xml.parse(tag));
							//timeline
							tag = '	<key id="'+m+'" time="'+i*stepTime+'" spin="0" >\n'+
							'		<object folder="' + folder.get("id") +'" file="' + m + '"/>\n' +
							'	</key>\n';
							timeline.addChild(Xml.parse(tag));
							k++;
							m++;
						}
					}
				}
				
			}
		}
		return xml;
	}
}