Java.perform(function () { 
    var c = Java.use('com.WaTF.WaTFBank.CheckPin');
    c.onAuthenticationFailed.implementation = function () {
        console.log('Hook!!');
        this.onAuthenticationSucceeded(null);
    }; 
}); 