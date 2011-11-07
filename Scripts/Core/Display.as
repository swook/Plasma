/*
 *    _____         _______ _______ _______ _______
 *   |_____] |      |_____| |______ |  |  | |_____|
 *   |       |_____ |     | ______| |  |  | |     |
 *
 *   Core/Display.as - UCI Display Manipulation and Properties
 */

Sys.Display = {};

Sys.Display.addProperty( "Brightness",
						 function ():Number {
							 var trans:Object = Sys.Display.Color;
							 trans.rb += 255;
							 trans.gb += 255;
							 trans.bb += 255;
							 var max:Number = Misc.Math.highest( [ trans.rb, trans.gb, trans.bb ] );
							 return int( max / 2.55 );
						 },
						 function ( num:Number ):Void {
							 if ( isNaN( num ) ) return;
							 if ( num < 0 ) num = 0;
							 else if ( num > 100 ) num = 100;
							 var trans:Object = Sys.Display.Color;
							 trans.rb += 255;
							 trans.gb += 255;
							 trans.bb += 255;
							 var scale:Number = 2.55 / Misc.Math.highest( [ trans.rb, trans.gb, trans.bb ] ) * num;
							 trans.rb = trans.rb * max - 255;
							 trans.gb = trans.gb * max - 255;
							 trans.bb = trans.bb * max - 255;
							 Sys.Display.Color = trans;
						 } );

Sys.Display.addProperty( "Color",
						 function ():Object {
							 if ( Sys.Display.Color_ == undefined ) {
								 Sys.Display.Color_ = new Color( UI );
								 var trans:Object = {
									 ra: 100,
									 rb: 0,
									 ga: 100,
									 gb: 0,
									 ba: 100,
									 bb: 0,
									 aa: 100,
									 ab: 0
								 };
								 Sys.Display.Color_.setTransform( trans );
								 return trans;
							 }
							 return Sys.Display.Color_.getTransform();
						 },
						 function ( trans:Object ):Void {
							 Sys.Display.Color_.setTransform( trans );
						 } );

Sys.Display.addProperty( "RGB",
						 function ():Number {
							 var trans:Object = Sys.Display.Color;
							 return ( trans.rb + 255 ) << 16 | ( trans.gb + 255 ) << 8 | ( trans.bb + 255 );
						 },
						 function ( num:Number ):Void {
							 var trans:Object = Sys.Display.Color;
							 trans.rb = ( num >> 16 ) - 255;
							 trans.gb = ( ( num >> 8 ) & 0xff ) - 255;
							 trans.bb = ( num & 0xff ) - 255;
							 Sys.Display.Color = trans;
						 } );

Sys.Display.addProperty( "Red",
						 function ():Number { return Sys.Display.Color.rb + 255; },
						 function ( num:Number ):Void {
							 var trans:Object = Sys.Display.Color;
							 trans.rb = num - 255;
							 Sys.Display.Color = trans;
						 } );

Sys.Display.addProperty( "Green",
						 function ():Number { return Sys.Display.Color.gb + 255; },
						 function ( num:Number ):Void {
							 var trans:Object = Sys.Display.Color;
							 trans.gb = num - 255;
							 Sys.Display.Color = trans;
						 } );

Sys.Display.addProperty( "Blue",
						 function ():Number { return Sys.Display.Color.bb + 255; },
						 function ( num:Number ):Void {
							 var trans:Object = Sys.Display.Color;
							 trans.bb = num - 255;
							 Sys.Display.Color = trans;
						 } );
