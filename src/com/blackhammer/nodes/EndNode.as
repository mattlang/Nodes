﻿package  com.blackhammer.nodes{		import flash.display.*;	import flash.events.*;	import flash.net.URLRequest;    import flash.net.navigateToURL;	import flash.media.Sound;	import flash.media.SoundChannel;	import com.blackhammer.nodes.*;	import com.greensock.TweenMax;	import com.greensock.easing.*;		public class EndNode extends Node{				public var _text:String;		public var _URL:String;		public var _cNameSprite:NodeLabel;		private var _fontSize = 14;		public var _backgroundColor1:uint = 0x555555;		public var _backgroundColor2:uint = 0x555555;  //0x666666		private var _Config:Node_Config;		private var _snd4 = new snd4();				public function EndNode(myDaddy,theText,theURL = "") {			super(myDaddy,"endnode");			_text = theText;			_URL = theURL;			_Config = Node_Config.getInstance();			var thecolor:uint = _backgroundColor1;			if (_URL != "") thecolor = _backgroundColor2;			_cNameSprite = new NodeLabel(this);			_cNameSprite.mShow(theText, _fontSize, false, true, thecolor);			addChild(_cNameSprite);			_cNameSprite.buttonMode = true;			buttonMode = true;			_cNameSprite.addEventListener(MouseEvent.CLICK,onMouseClick,false,0,true);			//special case to kludge yellow line for basenode			if(Node_Config.MAIN == _myDaddy._myDaddy){				this.updateOff();			}		}		private function onMouseClick(e:MouseEvent):void{			if(_URL ==""){				//is the center of a cluster				if (Node_Config.CURRENTURLNODE != "") Node_Config.CURRENTURLNODE.normalNode();				Node_Config.CURRENTURLNODE = ""				_myDaddy.showCluster(this);			}else{				// is an endNode				showNode();			}		}				private function normalNode():void{			TweenMax.to(_cNameSprite,.7,{scaleX:1, scaleY:1, alpha:1.0});			TweenMax.to(this,.7,{_myRadius:_myDaddy._radius});		}				public function showNode():void{			playSound(_snd4);			_myDaddy.normalNodes(this);						//////-----//////test----//////			var theNode = this;			//Rotate all siblings so selected cluster is at 0 degrees			var case1:Boolean = theNode._myDaddy._myAngle > Math.PI;					//var case2:Boolean = theNode._myDaddy._myAngle < -Math.PI;					var theCluster = theNode._myDaddy;			trace("theCluster",theCluster);			trace("theCluster._kidsNodeArray.length",theCluster._kidsNodeArray.length);			for (var j:int=0;j<theCluster._kidsNodeArray.length;j++){				var node = theCluster._kidsNodeArray[j];				//if (case1) node._myAngle -= Math.PI*2; 				//if (case2) node._myAngle += Math.PI*2; 				var myAngle2 = node._myAngle - theNode._myAngle;				//NEW OPENING NODE				if(theNode == node){					trace("node._myAngle",node._myAngle);					TweenMax.to(theNode,1.5,{_myAngle:0,_myRadius:_radius*2});					TweenMax.to(_cNameSprite,.7,{scaleX:1.2, scaleY:1.2, alpha:1.0});				}else{					TweenMax.to(theCluster._kidsNodeArray[j],1.5,{_myAngle:myAngle2}); //_myRadius:_radius, //shouldn't need to do that				}									}			if(Node_Config.CLUSTERCOUNT > 0){				TweenMax.to(Node_Config.MAIN,1.5,{x:Node_Config.SCREENW/(Node_Config.CLUSTERCOUNT +2), onComplete:showNodeDone});			}			//////-----//////test----//////			//////-----this was here before test----//////			//TweenMax.to(_cNameSprite,.7,{scaleX:1.4, scaleY:1.4, alpha:1.0});			//TweenMax.to(this,.7,{_myRadius:_radius*1.2});					}				private function showNodeDone():void{			Node_Config.CURRENTURLNODE = this;			var targetURL:URLRequest = new URLRequest(_URL);			navigateToURL(targetURL, "linkdisplay_iframe"); //"_blank"		}				/*override public function update(e:Event):void{			this.x = _myRadius*Math.cos(_myAngle);			this.y = _myRadius*Math.sin(_myAngle);			_gLine.clear();			_gLine.lineStyle(2, 0xFFD700, 1);			//_gLine.moveTo(this.x, this.y);            _gLine.lineTo(_myDaddy.x-this.x, _myDaddy.y-this.y);		}*/					}	}