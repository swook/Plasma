/*
 *    _____         _______ _______ _______ _______
 *   |_____] |      |_____| |______ |  |  | |_____|
 *   |       |_____ |     | ______| |  |  | |     |
 *
 *   Interaction/LongClick.as - Long Click/Press Handling
 */


Interaction.LongClick = {};
Interaction.LongClick.DELAY = 350;
Interaction.LongClick.INTERVAL = 150;

Interaction.LongClick.Init = function ( func ):Void {
	// NOTE: this == MovieClip
	if ( this.LongClick != undefined ) return;

	this.LongClick = {};
	this.LongClick.mc = this;
	this.LongClick.onEnterFrame = Interaction.LongClick.onEnterFrame;
}

Interaction.LongClick.cleanUp = function ():Void {
	// NOTE: this == MovieClip
	delete this.LongClick.last_t;
	delete this.LongClick.trail_done;
	MovieClip.removeListener( this.LongClick );
}

Interaction.LongClick.onEnterFrame = function ():Void {
	// NOTE: this == MovieClip.LongClick
	var dt:Number = Time.Ticks - this.start_t;
	if ( this.last_t ) {
		var ivl:Number = Interaction.LongClick.INTERVAL;
		if ( !this.trail_done ) {
			var inc:Number = ( ivl * 100000 / dt / dt ) >> 0;
			if ( inc < 10 ) this.trail_done = true;
			ivl += inc;
		}

		dt = Time.Ticks - this.last_t;
		if ( dt >= ivl ) {
			this.last_t = Time.Ticks;
			this.func_long.call( this.mc );
		}
		return;
	}
	else if ( dt > Interaction.LongClick.DELAY ) {
		this.last_t = Time.Ticks;
		this.func_long.call( this.mc );
	}
}


// Replace onPress
Interaction.LongClick.onPress = function ():Void {
	// NOTE: this == MovieClip
	if ( this.LongClick.func_long ) {
		this.LongClick.start_t = Time.Ticks;
		MovieClip.addListener( this.LongClick );
	}
	this.onPress_();
}

MovieClip.prototype.addProperty( "onPress",
								 function ():Function {
									 return Interaction.LongClick.onPress;
								 },
								 function ( func:Function ):Void {
									 this.onPress_ = func;
								 } );


// Replace onDragOut
Interaction.LongClick.onDragOut = function ():Void {
	// NOTE: this == MovieClip
	Interaction.LongClick.cleanUp.call( this );
	this.onDragOut_();
}

MovieClip.prototype.addProperty( "onDragOut",
								 function ():Function {
									 return Interaction.LongClick.onDragOut;
								 },
								 function ( func:Function ):Void {
									 this.onDragOut_ = func;
								 } );


// Replace onRelease
Interaction.LongClick.onRelease = function ():Void {
	// NOTE: this == MovieClip
	if ( !this.LongClick.last_t ) this.LongClick.func_short();
	Interaction.LongClick.cleanUp.call( this );
	this.onRelease_();
}

MovieClip.prototype.addProperty( "onRelease",
								 function ():Function {
									 return Interaction.LongClick.onRelease;
								 },
								 function ( func:Function ):Void {
									 this.onRelease_ = func;
								 } );


MovieClip.prototype.addProperty( "onLongClick",
								 function ():Function {
									 return this.LongClick.func_long;
								 },
								 function ( func:Function ):Void {
									 Interaction.LongClick.Init.call( this );
									 this.LongClick.func_long = func;
								 } );

MovieClip.prototype.addProperty( "onShortClick",
								 function ():Function {
									 return this.LongClick.func_short;
								 },
								 function ( func:Function ):Void {
									 Interaction.LongClick.Init.call( this );
									 this.LongClick.func_short = func;
								 } );
