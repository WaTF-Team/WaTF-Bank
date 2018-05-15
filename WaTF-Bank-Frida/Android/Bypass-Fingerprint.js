Java.perform(function () { 
    var c = Java.use('com.WaTF.WaTFBank.CheckPin');
    c.onAuthFailed.implementation = function () {
        console.log('Hook');
        this.onAuthSuccess(null);
    }; 
}); 