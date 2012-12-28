﻿package  com.blackhammer.nodes{		import flash.display.*;	import flash.events.*;	import flash.net.URLRequest;    import flash.net.navigateToURL;	import flash.media.Sound;	import flash.media.SoundChannel;	import com.blackhammer.nodes.*;	import com.greensock.TweenMax;	import com.greensock.easing.*;		public class Node extends MovieClip{				public var _myDaddy:Object;		public var _myAngle:Number = 0;		public var _myRadius:Number = 0;		public var _lineSprite:Sprite;		public var _gLine:Graphics;		public var _type:String;		public var _cacheAngle:Number;		public var _radius:Number = 125;		public var _lineColor:uint;				public var _Config:Node_Config;				public function Node(myDaddy,type) {			_myDaddy = myDaddy;			_lineColor = Node_Config.NODELINECOLOR;			_type = type;			_lineSprite  = new Sprite();			_gLine = _lineSprite.graphics;			addChild(_lineSprite);							this.addEventListener(Event.ENTER_FRAME,update,false,0,true);		}				public function updateOn():void{			//this.addEventListener(Event.ENTER_FRAME,update,false,0,true);		}				public function updateOff():void{			this.removeEventListener(Event.ENTER_FRAME,update);		}				public function playSound(theSound):void{			var chan:SoundChannel = theSound.play();		}				public function update(e:Event):void{			this.x = _myRadius*Math.cos(_myAngle);			this.y = _myRadius*Math.sin(_myAngle);			_gLine.clear();			_gLine.lineStyle(2, _lineColor, 1, true); //0xFFD700//0xFF0000			//_gLine.moveTo(this._myDaddy._myDaddy.x, this._myDaddy._myDaddy.y);            _gLine.lineTo(_myDaddy._myDaddy.x-this.x, _myDaddy._myDaddy.y-this.y);		}	}	}