Java.perform(function () { 
	var c = Java.use('com.WaTF.WaTFBank.Login');
	c.isRooted.implementation = function () {
		console.log('Hook');
		return false;
    	}; 
});