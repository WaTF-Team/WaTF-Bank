Java.perform(function () { 
	var c = Java.use('com.WaTF.WaTFBank.CheckPin');
		c.checkPin.implementation = function () {
			console.log('Hook!!');
      	  		for(var i=0; i<9999; i++)
        		{
				var x = this.md5(i+"")
            			var result = this.checkPin(x); 
            			console.log("enter : "  + i); 
				if (result) 
				{
					console.log("This is a pin!!!")
					return true
				}
        		}
		return false
    	}; 
}); 
