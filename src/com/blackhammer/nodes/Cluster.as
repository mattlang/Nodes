﻿package com.blackhammer.nodes {		import flash.display.*	import flash.events.*	import flash.media.Sound;	import flash.media.SoundChannel;	import com.blackhammer.nodes.*;	import com.greensock.TweenMax;	import com.greensock.easing.*;		public class Cluster extends Node{		public var _clusterName:String;		public var _centerNode:EndNode;		private var _kidsNodeArray:Array = [];		private var _Config:Node_Config;		private var _sndList:Array = [new snd1(),new snd2(),new snd3()];				public function Cluster(myDaddy,clusterName:String, kidsList:Array) {			super(myDaddy,"cluster");			_clusterName = clusterName;			_Config = Node_Config.getInstance();			var numOfChildren = kidsList.length;			for(var i:uint=0;i<numOfChildren;i++){				if(kidsList[i].hasOwnProperty("cat_URL")){					//is an end node not a new cluster					_kidsNodeArray.push(new EndNode(this,kidsList[i].cat_name, kidsList[i].cat_URL));					//trace(_kidsNodeArray[i]._text, _kidsNodeArray[i]._URL);				}else{					//is a new cluster					_kidsNodeArray.push(new Cluster(this,kidsList[i].cat_name, kidsList[i].kidsArray));					//trace("recursive instantiation");					//trace(_kidsNodeArray[i]._clusterName,_kidsNodeArray[i]._kidsNodeArray);				}				addChild(_kidsNodeArray[i]);				_kidsNodeArray[i].alpha = 0;			}			_centerNode = new EndNode(this,_clusterName);			addChild(_centerNode);						//special case to kludge yellow line for basenode			if(Node_Config.MAIN == _myDaddy){				this.updateOff();			}		}				public function showCluster(theNode= null):void{ //theNode is the _centernode of a cluster!!!!!			playRandSound();			//node should be == to _centerNode but I don't know if the test is needed.			trace("_centerNode === theNode",_centerNode == theNode)			trace("Node_Config.CURRENTCLUSTER",Node_Config.CURRENTCLUSTER);			//write something that distributes nodes according to ClusterCount			var openChildren:Boolean = true;			if (theNode != null){ /// so it's not the first node which is not cliked on but instantiated literally				//case of selecting a new endnode center of another cluster on the same parent				if (Node_Config.CURRENTCLUSTER._myDaddy == theNode._myDaddy._myDaddy && Node_Config.CURRENTCLUSTER != theNode._myDaddy){					trace("case where selected new endnode on cluster same as current cluster");					Node_Config.CURRENTCLUSTER.hideChildren();					TweenMax.to(Node_Config.CURRENTCLUSTER,1.5,{								_myAngle:Node_Config.CURRENTCLUSTER._cacheAngle,								_myRadius:_radius});				}else if(Node_Config.CURRENTCLUSTER == theNode._myDaddy._myDaddy){ //Adding an open node. thats ok maybe nothting to do					trace("case where selected new cluster and the current is infoVis???");					Node_Config.CLUSTERCOUNT ++;				}else if(Node_Config.MAIN._baseNode ==  theNode._myDaddy){ //clicked the start node					trace("case where selected the baseNode");					openChildren = false;					if(Node_Config.CURRENTCLUSTER != Node_Config.MAIN._baseNode){						Node_Config.CLUSTERCOUNT --;						Node_Config.CURRENTCLUSTER.hideChildren();						TweenMax.to(Node_Config.CURRENTCLUSTER,1.5,{								_myRadius:_radius});						Node_Config.CURRENTCLUSTER=Node_Config.MAIN._baseNode;					}				}else if(Node_Config.CURRENTCLUSTER ==  theNode._myDaddy){ //clicked on the center of the current node. Turn off?					trace("case where selected the center of current node");					theNode._myDaddy.hideChildren();					Node_Config.CURRENTCLUSTER = Node_Config.MAIN._baseNode;					Node_Config.CLUSTERCOUNT --;										var theCluster = theNode._myDaddy._myDaddy;					for (var h:int=0;h<theCluster._kidsNodeArray.length;h++){						var node = theCluster._kidsNodeArray[h];						var myAngle:Number = theCluster._kidsNodeArray[h]._cacheAngle;						if(theNode._myDaddy == node){							//NEW OPENING NODE							TweenMax.to(theNode._myDaddy,1.5,{								_myAngle:theNode._myDaddy._cacheAngle,								_myRadius:_radius});						}else{							TweenMax.to(theCluster._kidsNodeArray[h],1.5,{_myAngle:myAngle}); //_myRadius:_radius, //shouldn't need to do that						}											}										TweenMax.to(theNode._myDaddy,1.5,{								_myAngle:theNode._myDaddy._cacheAngle,								_myRadius:_radius});					openChildren = false;				} else{ //selecting node on different tree? is that possible in this scope					trace("else");				}								if(Node_Config.CLUSTERCOUNT > 0){					TweenMax.to(Node_Config.MAIN,1.5,{x:Node_Config.SCREENW/(Node_Config.CLUSTERCOUNT +1)});				}				if (openChildren){					//Rotate all siblings so selected cluster is at 0 degrees					var case1:Boolean = theNode._myDaddy._myAngle > Math.PI;							//var case2:Boolean = theNode._myDaddy._myAngle < -Math.PI;							theCluster = theNode._myDaddy._myDaddy;					for (var j:int=0;j<theCluster._kidsNodeArray.length;j++){						node = theCluster._kidsNodeArray[j];						//if (case1) node._myAngle -= Math.PI*2; 						//if (case2) node._myAngle += Math.PI*2; 						var myAngle2 = node._myAngle - theNode._myDaddy._myAngle;						//NEW OPENING NODE						if(theNode._myDaddy == node){							trace("node._myAngle",node._myAngle);							TweenMax.to(theNode._myDaddy,1.5,{_myAngle:0,_myRadius:_radius*2.5});						}else{							TweenMax.to(theCluster._kidsNodeArray[j],1.5,{_myAngle:myAngle2}); //_myRadius:_radius, //shouldn't need to do that						}											}					Node_Config.CURRENTCLUSTER = theNode._myDaddy;				}			}			//trace("x: ",this.x,"y: ",this.y);			if (openChildren){			//Show the kids				var angle:Number = 2*Math.PI/_kidsNodeArray.length;				//?????///TweenMax.to(this,2,{_myRadius:0, alpha:1}); //x:Node_Config.CENTERX,y:Node_Config.CENTERY				//trace("_kidsNodeArray",_kidsNodeArray);				//if(_myDaddy != Node_Config.MAIN) _myDaddy.recedeCluster(theNode);				for(var i:uint=0;i<_kidsNodeArray.length;i++){					node = _kidsNodeArray[i];					myAngle = angle*(i+1)					_kidsNodeArray[i]._cacheAngle = myAngle;					//node.updateOn();					TweenMax.to(_kidsNodeArray[i],1.5,{alpha:1, _myRadius:_radius, _myAngle:myAngle});	////,onComplete:turnUpdateOff,onCompleteParams:[i,_kidsNodeArray.length]//////,onComplete:showmeprops,onCompleteParams:[i]				}				/*if (_clusterName != "Info-Vis"){					TweenMax.to(_centerNode,1.5,{y:-100,scaleX:4,scaleY:4, _myRadius:0});					addChildAt(_centerNode,0);				}				TweenMax.to(Node_Config.CURRENTCLUSTER._centerNode,1.5,{y:0,scaleX:1,scaleY:1, _myRadius:_radius});				addChildAt(Node_Config.CURRENTCLUSTER._centerNode,numChildren);*/			}		}				public function normalNodes(selectNode:Node):void{			trace("in normalNodes", selectNode);			for(var i:uint=0;i<_kidsNodeArray.length;i++){				TweenMax.to(_kidsNodeArray[i]._cNameSprite,.7,{scaleX:1, scaleY:1});				TweenMax.to(_kidsNodeArray[i],.7,{_myRadius:_radius});							}		}				public function hideChildren(node = null):void{			for(var i:uint=0;i<_kidsNodeArray.length;i++){				var node = _kidsNodeArray[i];				TweenMax.to(node,.5,{alpha:0,_myRadius:0,onComplete:hideChildrenDone});  //,_myAngle:0			}		}		private function hideChildrenDone():void{			for(var i:uint=0;i<_kidsNodeArray.length;i++){				var node = _kidsNodeArray[i];				TweenMax.to(node,0,{_myAngle:0}); //,onComplete:node.updateOff			}		}		override public function update(e:Event):void{			this.x = _myRadius*Math.cos(_myAngle);			this.y = _myRadius*Math.sin(_myAngle);			_gLine.clear();			_gLine.lineStyle(2, 0xFF0000, 1);			//_gLine.moveTo(this.x/_kidsNodeArray.length, this.y/_kidsNodeArray.length);            _gLine.lineTo(_myDaddy.x-this.x, _myDaddy.y-this.y);		}				private function playRandSound():void{			var randNum:uint = Math.floor(Math.random()*3);			var chan:SoundChannel = _sndList[randNum].play();		}	}	}