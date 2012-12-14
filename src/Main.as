﻿package  {	//by Matthew Schlanger ©2012		import flash.display.*;	import flash.events.Event;	import flash.events.ProgressEvent;	import flash.net.URLRequest;	import flash.events.MouseEvent;	import flash.utils.getDefinitionByName;	import flash.utils.getTimer;		import flash.media.Sound;	import flash.media.SoundChannel;    import flash.net.FileReference;		import com.greensock.TweenMax;	import com.greensock.easing.*;		import com.blackhammer.util.BHUtils;	import com.blackhammer.util.LoadXML;	import com.blackhammer.nodes.*;	import flash.xml.XMLDocument;	import flash.xml.XMLNode;	import flash.text.TextField;	import flash.text.TextFormat;		public class Main extends MovieClip{				private var _appMetaData:LoadXML;		private var _nodeObject:Object = {};		private var _Config:Node_Config;		public var _baseNode:Cluster;				public function Main():void{			trace("document class");			if ( stage ) 	init();			else			addEventListener(Event.ADDED_TO_STAGE, init);		}				private function init(e:Event = null):void 		{			removeEventListener(Event.ADDED_TO_STAGE, init);			//addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);			_Config = Node_Config.getInstance(); 			Node_Config.setMain(this);			Node_Config.SCREENW = this.stage.stageWidth;			Node_Config.SCREENH = this.stage.stageHeight;			_Config.setStageVariables();			trace(Node_Config.SCREENW,Node_Config.SCREENH);			///LOAD XML			_appMetaData = new LoadXML("structure.xml");			_appMetaData.addEventListener("xmlLoaded", onLoadXML, false, 0, true);		}				private function buildNodeset():void{			trace("catname",_nodeObject.cat_name);			trace("_nodeObject.kidsArray",_nodeObject.kidsArray);			_baseNode = new Cluster(this,_nodeObject.cat_name,_nodeObject.kidsArray);			addChild(_baseNode);			this.x = Node_Config.CENTERX;			this.y = Node_Config.CENTERY;			Node_Config.CURRENTCLUSTER = _baseNode;			Node_Config.CLUSTERCOUNT = 1;			_baseNode.showCluster();		}				private function parseNodes(xmNode:XML,currentObj:Object){			currentObj.cat_name = xmNode.@catname; // xmNode.attributes.name 			if(xmNode.children().length()>0){				currentObj.kidsArray = [];				for (var i=0; i<xmNode.children().length();i++){					currentObj.kidsArray[i]={};					parseNodes(xmNode.children()[i], currentObj.kidsArray[i]);				}			} else { 				// it has not child nodes, so it must be a URL node				// grab the "url" attribute of the XML node, save it to a field of the current object				currentObj.cat_URL = xmNode.@caturl			}					}				private function onLoadXML(e:Event):void{			_appMetaData.removeEventListener("xmlLoaded", onLoadXML);			//trace("XML Loaded");			trace(e);			//trace(_appMetaData.xmlData);			//trace("firstchild",_appMetaData.xmlData.firstChild as XMLDocument);			//trace("cat.firstChild",_appMetaData.xmlData.cat[0]);			parseNodes(_appMetaData.xmlData,_nodeObject);			buildNodeset();		}					}	}