function invokepinmethod() {
	try {
		var className = "Pin";
        var funcName = "- checkPin";
        var hook = eval('ObjC.classes.' + className + '["' + funcName + '"]');
        Interceptor.attach(hook.implementation, {
          onEnter: function(args) {
            console.log("[*] Class Name: " + className);
            console.log("[*] Method Name: " + funcName);
            var abc = new ObjC.Object(args[0]);
            abc.nextPage();
            console.log("\t[-] Invoke method for Bypass ");
          }
        });
	} catch(err) {
		console.log("[-] Error: " + err.message);
	}
}

if (ObjC.available) {
	invokepinmethod();
} else {
 	send("error: Objective-C Runtime is not available!");
}
