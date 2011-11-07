/*
 *    _____         _______ _______ _______ _______
 *   |_____] |      |_____| |______ |  |  | |_____|
 *   |       |_____ |     | ______| |  |  | |     |
 *
 *   Core/Data.as - Data/Settings Management
 */

var Data:Object = {};
Data.Loaded = {};

// Public method
// USE THIS ONE NOT Data._Set!
Data.Set = function ( setting:String, data, filen:String ) {
	return Data.CheckLoaded( filen ).Set( setting, data );
}

// Public method
// USE THIS ONE NOT Data._Unset!
Data.Unset = function ( setting:String, filen:String ):Boolean {
	return Data.CheckLoaded( filen ).Unset( setting );
}

// Public method
// USE THIS ONE NOT Data._Get!
Data.Get = function ( setting:String, filen:String ) {
	return Data.CheckLoaded( filen ).Get( setting );
}


/**********************************************************
 * Do not use the functions below, they are for processing
 * the public functions Data.Set, Data.Unset and Data.Get
 ***********************************************************/

Data.MaxUnsavedChanges = 8;														//  8 changes
Data.MaxDelayTillSave = 15000;													// 15 seconds
Data.MaxDelayTillUnload = 120000;												//  2 minutes

Data.CheckLoaded = function ( filen:String ):Object {
	if ( filen ) {
		if ( filen != UCI_NAME )												// If name provided and not UCI name
			filen = UCI_NAME + "_" + filen;										// Use UCI's name + _name
	}																			// Eg. "data" for a UCI called "ABC"
	else																		// would produce "ABC_data.so"
		filen = UCI_NAME;														// Use UCI name for SO file

	if ( Data.Loaded[ filen ] == undefined ) {
		Data.Loaded[ filen ] = {};
		var obj:Object = Data.Loaded[ filen ];
		obj.sobj = SharedObject.getLocal( filen );
		obj.name = filen;
		obj.changed = 0;
		obj.lastSaved = getTimer();

		obj.Set = Data._Set;
		obj.Get = Data._Get;
		obj.Unset = Data._Unset;
	}
	return Data.Loaded[ filen ];
}

Data._Set = function ( setting:String, data ) {
	if ( this.sobj.data[ setting ] != data ) {
		this.sobj.data[ setting ] = data;
		this.changed++;
	}
	return data;
}

Data._Unset = function ( setting:String ):Boolean {
	if ( this.sobj.data[ setting ] ) {
		delete this.sobj.data[ setting ];
		return this.sobj.flush();
	}
	else return false;
}

Data._Get = function ( setting:String ) {
	return this.sobj.data[ setting ];
}

Data.Sync = function ():Void {
	var chksync:Function = function ( obj:Object ):Number {
		var tdiff:Number =  getTimer() - obj.lastSaved;
		if ( obj.changed == 0 ) return tdiff;
		if ( obj.changed > Data.MaxUnsavedChanges || tdiff > Data.MaxDelayTillSave ) {
			if ( obj.sobj.flush() ) {
				obj.changed = 0;
				obj.lastSaved = getTimer();
			}
		}
		return tdiff;
	}

	var sync:Function = function ( obj:Object ):Void {
		var dobj:Object;
		var tdiff:Number;
		for ( var n:String in obj.Loaded ) {
			dobj = obj.Loaded[ n ];
			tdiff = chksync( dobj );
			if ( tdiff > Data.MaxDelayTillUnload && dobj.changed == 0 ) {
				dobj.sobj.clear();
				delete obj.Loaded[ n ];
			}
		}
	}
	sync( Data );
	sync( Plasma.Data );
	chksync( Plasma.Data );
}

Data.Unload = function ():Void {
	var unload:Function = function ( obj:Object ):Void {
		var dobj:Object;
		for ( var n:String in obj.Loaded ) {
			dobj = obj.Loaded[ n ];
			if ( dobj.changed > 0 )
				dobj.sobj.flush();
			dobj.sobj.clear();
			delete obj.Loaded[ n ];
		}
	}
	unload( Data );
	unload( Plasma.Data );

	if ( Plasma.Data.changed > 0 )
		Plasma.Data.sobj.flush();												// Save Plasma.Data to disk
}																				// but don't close for future


/* Plasma only. Not for UCIs */

Plasma.Data = {};

Plasma.Data.name = "Plasma";
Plasma.Data.sobj = SharedObject.getLocal( Plasma.Data.name );					// Load shared obj. This stays
Plasma.Data.changed = 0;
Plasma.Data.lastSaved = getTimer();
Plasma.Data.Loaded = {};

Plasma.Data.CheckLoaded = function ( filen:String ):Object {
	filen = "Plasma_"+ filen;
	if ( Plasma.Data.Loaded[ filen ] == undefined ) {
		Plasma.Data.Loaded[ filen ] = {};
		var obj:Object = Plasma.Data.Loaded[ filen ];
		obj.sobj = SharedObject.getLocal( filen );
		obj.name = filen;
		obj.changed = 0;
		obj.lastSaved = getTimer();

		obj.Set = Data._Set;
		obj.Get = Data._Get;
		obj.Unset = Data._Unset;
	}
	return Plasma.Data.Loaded[ filen ];
}

Plasma.Data.Set = function ( setting:String, data, filen:String ) {
	if ( filen )
		return Plasma.Data.CheckLoaded( filen ).Set( setting, data );

	if ( Plasma.Data.sobj.data[ setting ] != data ) {
		Plasma.Data.sobj.data[ setting ] = data;
		Plasma.Data.changed++;
	}
	return data;
}

Plasma.Data.Unset = function ( setting:String ) {
	if ( filen )
		return Plasma.Data.CheckLoaded( filen ).Set( setting, data );

	if ( Plasma.Data.sobj.data[ setting ] == undefined )
		return true;

	delete Plasma.Data.sobj.data[ setting ];
}

Plasma.Data.Get = function ( setting:String ) {
	if ( filen )
		return Plasma.Data.CheckLoaded( filen ).Get( setting );

	return this.sobj.data[ setting ];
}

