/*

AWD file loading example in Away3d

Demonstrates:

How to use the Loader3D object to load an embedded internal awd model.
How to create character interaction
How to set custom material on a model.

Code by Rob Bateman and LoTh
rob@infiniteturtles.co.uk
http://www.infiniteturtles.co.uk
3dflashlo@gmail.com
http://3dflashlo.wordpress.com

Model and Map by LoTH
3dflashlo@gmail.com
http://3dflashlo.wordpress.com

This code is distributed under the MIT License

Copyright (c) The Away Foundation http://www.theawayfoundation.org

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the “Software”), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

 */
package
{
    import away3d.cameras.lenses.*;
    import away3d.containers.*;
    import away3d.controllers.*;
    import away3d.debug.*;
    import away3d.events.*;
    import away3d.library.*;
    import away3d.loaders.*;
    import away3d.loaders.parsers.*;
    import away3d.materials.methods.*;
    
    import flash.display.*;
    import flash.events.*;
    import flash.filters.*;
    import flash.geom.*;
    import flash.net.*;
    import flash.text.*;
	
	
    [SWF(backgroundColor="#333338", frameRate="60", quality="LOW")]
    public class Intermediate_AWDTEST extends Sprite
	{
    	//signature swf
    	[Embed(source="/../embeds/signature.swf", symbol="Signature")]
    	public var SignatureSwf:Class;
		
        //engine variables
        private var _view:View3D;
		private var _signature:Sprite;
        private var _stats:AwayStats;
        private var _cameraController:HoverController;
        
        //navigation
        private var _prevMouseX:Number;
        private var _prevMouseY:Number;
        private var _mouseMove:Boolean;
        private var _cameraHeight:Number = 0;
        
        private var _eyePosition:Vector3D;
        private var cloneActif:Boolean = false;
        private var _text:TextField;
		
        private var _specularMethod:FresnelSpecularMethod;
        private var _shadowMethod:NearShadowMapMethod;
        
        /**
         * Constructor
         */
        public function Intermediate_AWDTEST()
		{
            init();
        }
        
        /**
         * Global initialise function
         */
        private function init():void
		{
            initEngine();
            initText();
			initListeners();
			
			AssetLibrary.enableParser(AWD2Parser);
			AssetLibrary.addEventListener(AssetEvent.ASSET_COMPLETE, onAssetComplete);
			
			//kickoff asset loading
			var loader:Loader3D = new Loader3D();
			loader.load(new URLRequest("assets/MonsterHead.awd"));
			
			_view.scene.addChild(loader);
        }
        
        /**
         * Initialise the engine
         */
        private function initEngine():void
		{
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
            
			//create the view
            _view = new View3D();
			_view.backgroundColor = 0x333338;
            addChild(_view);
            
			//create custom lens
            _view.camera.lens = new PerspectiveLens(70);
            _view.camera.lens.far = 30000;
            _view.camera.lens.near = 1;
            
			//setup controller to be used on the camera
            _cameraController = new HoverController(_view.camera, null, 180, 0, 1000, 10, 90);
            _cameraController.tiltAngle = 0;
            _cameraController.panAngle = 180;
            _cameraController.minTiltAngle = -60;
            _cameraController.maxTiltAngle = 60;
            _cameraController.autoUpdate = false;
            
            
            //add signature
			addChild(_signature = new SignatureSwf());
            
            //add stats
            addChild(_stats = new AwayStats(_view, true, true));
        }
		
		/**
         * Create an instructions overlay
         */
        private function initText():void
		{
            _text = new TextField();
            _text.defaultTextFormat = new TextFormat("Verdana", 11, 0xFFFFFF);
			_text.embedFonts = true;
			_text.antiAliasType = AntiAliasType.ADVANCED;
			_text.gridFitType = GridFitType.PIXEL;
            _text.width = 300;
            _text.height = 250;
            _text.selectable = false;
            _text.mouseEnabled = true;
            _text.wordWrap = true;
            _text.filters = [new DropShadowFilter(1, 45, 0x0, 1, 0, 0)];
            addChild(_text);
        }
        
        /**
         * Initialise the listeners
         */
        private function initListeners():void
		{
            //add render loop
            addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
            //navigation
            stage.addEventListener(MouseEvent.MOUSE_DOWN, onStageMouseDown);
            stage.addEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove);
            stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseLeave);
            stage.addEventListener(MouseEvent.MOUSE_WHEEL, onStageMouseWheel);
            stage.addEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
			
            //add resize event
            stage.addEventListener(Event.RESIZE, onResize);
            onResize();
        }
		
		private function onAssetComplete(event:AssetEvent):void
		{
			trace(event.asset.name);
		}
		
        /**
         * Render loop
         */
        private function onEnterFrame(event:Event):void
		{
			
            //update camera controler
            _cameraController.update();
		
			
            //update view
            _view.render();
        }
    
		
        /**
         * stage listener and mouse control
         */
        private function onResize(event:Event=null):void
		{
            _view.width = stage.stageWidth;
            _view.height = stage.stageHeight;
            _stats.x = stage.stageWidth - _stats.width;
            _signature.y = stage.stageHeight - _signature.height;
        }
        
        private function onStageMouseDown(ev:MouseEvent):void
		{
            _prevMouseX = ev.stageX;
            _prevMouseY = ev.stageY;
            _mouseMove = true;
        }
        
        private function onStageMouseLeave(event:Event):void
		{
            _mouseMove = false;
        }
        
        private function onStageMouseMove(ev:MouseEvent):void
		{
            if (_mouseMove) {
                _cameraController.panAngle += (ev.stageX - _prevMouseX);
                _cameraController.tiltAngle += (ev.stageY - _prevMouseY);
            }
            _prevMouseX = ev.stageX;
            _prevMouseY = ev.stageY;
        }
        
        /**
         * mouseWheel listener
         */
        private function onStageMouseWheel(ev:MouseEvent):void
		{
            _cameraController.distance -= ev.delta * 5;
			
			_cameraHeight = (_cameraController.distance < 600)? (600 - _cameraController.distance)/2 : 0;
			
            if (_cameraController.distance < 100)
                _cameraController.distance = 100;
            else if (_cameraController.distance > 2000)
                _cameraController.distance = 2000;
        }
    }
}
