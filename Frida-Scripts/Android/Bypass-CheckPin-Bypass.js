Java.perform(function () { 
	var c = Java.use('com.WaTF.WaTFBank.CheckPin');
    	c.checkPin.implementation = function () {
		console.log('Hook!!');
        	return true;
    	}; 
}); 