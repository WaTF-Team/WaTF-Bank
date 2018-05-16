if (ObjC.available)
{
    try
    {
        var className = "Pin";
        var funcName = "- checkPin";
        var hook = eval('ObjC.classes.' + className + '["' + funcName + '"]');
        Interceptor.attach(hook.implementation, {
          onLeave: function(retval) {
            console.log("[*] Class Name: " + className);
            console.log("[*] Method Name: " + funcName);
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
