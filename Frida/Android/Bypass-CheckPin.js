Java.perform(function () { 
	var c = Java.use('com.WaTF.WaTFBank.CheckPin');
    	c.checkPin.implementation = function () {
        	return true;
    	}; 
}); 