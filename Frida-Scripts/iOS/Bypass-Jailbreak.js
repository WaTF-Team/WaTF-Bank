if (ObjC.available)
{
    try
    {
        var className = "JailbreakDetection";
        var funcName = "- checkFile";
        var hook = eval('ObjC.classes.' + className + '["' + funcName + '"]');
        var className2 = "JailbreakDetection";
        var funcName2 = "- checkRead";
        var hook2 = eval('ObjC.classes.' + className2 + '["' + funcName2 + '"]');
        var className3 = "JailbreakDetection";
        var funcName3 = "- checkWrite";
        var hook3 = eval('ObjC.classes.' + className3 + '["' + funcName3 + '"]');
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
            console.log("[*] Class Name: " + className2);
            console.log("[*] Method Name: " + funcName2);
            retval.replace("0x1");
            console.log("\t[-] Type of return value: " + typeof retval);
            console.log("\t[-] Return Value: " + retval);
          }
        });

        Interceptor.attach(hook3.implementation, {
          onLeave: function(retval) {
            console.log("[*] Class Name: " + className3);
            console.log("[*] Method Name: " + funcName3);
            retval.replace("0x1");
            console.log("\t[-] Type of return value: " + typeof retval);
            console.log("\t[-] Return Value: " + retval);
          }
        });
    }
    catch(err)
    {
        console.log("[!] Exception2: " + err.message);
    }
}
else
{
    console.log("Objective-C Runtime is not available!");
}
