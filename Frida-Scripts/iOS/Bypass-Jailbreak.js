function bypassJailbreakDetection() {
	try {
		var className = "JailbreakDetection";
        var funcName = "- checkFile";
        var hook = eval('ObjC.classes.' + className + '["' + funcName + '"]');
        var funcName2 = "- checkRead";
        var hook2 = eval('ObjC.classes.' + className + '["' + funcName2 + '"]');
        var funcName3 = "- checkWrite";
        var hook3 = eval('ObjC.classes.' + className + '["' + funcName3 + '"]');
        Interceptor.attach(hook.implementation, {
          onLeave: function(retval) {
            console.log("[*] Class Name: " + className);
            console.log("[*] Method Name: " + funcName);
            retval.replace("0x1");
            console.log("\t[-] Type of return value: " + typeof retval);
            console.log("\t[-] Return Value: " + retval);
          }
        });
        Interceptor.attach(hook2.implementation, {
          onLeave: function(retval) {
            console.log("[*] Method Name: " + funcName2);
            retval.replace("0x1");
            console.log("\t[-] Type of return value: " + typeof retval);
            console.log("\t[-] Return Value: " + retval);
          }
        });

        Interceptor.attach(hook3.implementation, {
          onLeave: function(retval) {
            console.log("[*] Method Name: " + funcName3);
            retval.replace("0x1");
            console.log("\t[-] Type of return value: " + typeof retval);
            console.log("\t[-] Return Value: " + retval);
          }
        });
	} catch(err) {
		console.log("[-] Error: " + err.message);
	}
}

if (ObjC.available) {
	bypassJailbreakDetection();
} else {
 	send("error: Objective-C Runtime is not available!");
}
