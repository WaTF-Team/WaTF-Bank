#import "JailbreakDetection.h"

@interface JailbreakDetection()
@end

@implementation JailbreakDetection

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    if([self checkFile]&&[self checkRead]&&[self checkWrite])
    {
        if([Util getKeychain:@"token"]==nil || [[Util getKeychain:@"token"] isEqualToString:@""])
        {
            [Util changeView:self :@"Login"];
        }
        else
        {
            [Util changeView:self :@"Pin"];
        }
    }
    else
    {
        [Util changeView:self :@"Jailbreak"];
    }
}

-(BOOL)checkFile
{
    BOOL isDirectory  = false;
    if([[NSFileManager defaultManager] fileExistsAtPath:@"/Applications/Cydia.app" isDirectory:&isDirectory]
        || [[NSFileManager defaultManager] fileExistsAtPath:@"/Applications/blackra1n.app" isDirectory:&isDirectory]
        || [[NSFileManager defaultManager] fileExistsAtPath:@"/Applications/FakeCarrier.app" isDirectory:&isDirectory]
        || [[NSFileManager defaultManager] fileExistsAtPath:@"/Applications/Icy.app" isDirectory:&isDirectory]
        || [[NSFileManager defaultManager] fileExistsAtPath:@"/Applications/IntelliScreen.app" isDirectory:&isDirectory]
        || [[NSFileManager defaultManager] fileExistsAtPath:@"/Applications/MxTube.app" isDirectory:&isDirectory]
        || [[NSFileManager defaultManager] fileExistsAtPath:@"/Applications/RockApp.app" isDirectory:&isDirectory]
        || [[NSFileManager defaultManager] fileExistsAtPath:@"/Applications/SBSetttings.app" isDirectory:&isDirectory]
        || [[NSFileManager defaultManager] fileExistsAtPath:@"/Applications/WinterBoard.app" isDirectory:&isDirectory]
        || [[NSFileManager defaultManager] fileExistsAtPath:@"/private/var/lib/apt/" isDirectory:&isDirectory]
        || [[NSFileManager defaultManager] fileExistsAtPath:@"/private/var/lib/cydia/" isDirectory:&isDirectory]
        || [[NSFileManager defaultManager] fileExistsAtPath:@"/private/var/mobileLibrary/SBSettingsThemes/" isDirectory:&isDirectory]
        || [[NSFileManager defaultManager] fileExistsAtPath:@"/private/var/tmp/cydia.log" isDirectory:&isDirectory]
        || [[NSFileManager defaultManager] fileExistsAtPath:@"/private/var/stash/" isDirectory:&isDirectory]
        || [[NSFileManager defaultManager] fileExistsAtPath:@"/usr/libexec/cydia/" isDirectory:&isDirectory]
        || [[NSFileManager defaultManager] fileExistsAtPath:@"/usr/binsshd" isDirectory:&isDirectory]
        || [[NSFileManager defaultManager] fileExistsAtPath:@"/usr/sbinsshd" isDirectory:&isDirectory]
        || [[NSFileManager defaultManager] fileExistsAtPath:@"/usr/libexec/cydia/" isDirectory:&isDirectory]
        || [[NSFileManager defaultManager] fileExistsAtPath:@"/usr/libexec/sftp-server" isDirectory:&isDirectory]
        || [[NSFileManager defaultManager] fileExistsAtPath:@"/Systetem/Library/LaunchDaemons/com.ikey.bbot.plist" isDirectory:&isDirectory]
        || [[NSFileManager defaultManager] fileExistsAtPath:@"/System/Library/LaunchDaemons/com.saurik.Cy@dia.Startup.plist" isDirectory:&isDirectory]
        || [[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/MobileSubstrate.dylib" isDirectory:&isDirectory]
        || [[NSFileManager defaultManager] fileExistsAtPath:@"/var/cache/apt/" isDirectory:&isDirectory]
        || [[NSFileManager defaultManager] fileExistsAtPath:@"/var/lib/apt/" isDirectory:&isDirectory]
        || [[NSFileManager defaultManager] fileExistsAtPath:@"/var/lib/cydia/" isDirectory:&isDirectory]
        || [[NSFileManager defaultManager] fileExistsAtPath:@"/var/log/syslog" isDirectory:&isDirectory]
        || [[NSFileManager defaultManager] fileExistsAtPath:@"/private/var/cache/apt/" isDirectory:&isDirectory]
        || [[NSFileManager defaultManager] fileExistsAtPath:@"/private/var/lib/apt/" isDirectory:&isDirectory]
        || [[NSFileManager defaultManager] fileExistsAtPath:@"/private/var/lib/cydia/" isDirectory:&isDirectory]
        || [[NSFileManager defaultManager] fileExistsAtPath:@"/private/var/log/syslog" isDirectory:&isDirectory]
        || [[NSFileManager defaultManager] fileExistsAtPath:@"/bin/bash" isDirectory:&isDirectory]
        || [[NSFileManager defaultManager] fileExistsAtPath:@"/bin/sh" isDirectory:&isDirectory]
        || [[NSFileManager defaultManager] fileExistsAtPath:@"/private/etc/apt/" isDirectory:&isDirectory]
        || [[NSFileManager defaultManager] fileExistsAtPath:@"/etc/apt/" isDirectory:&isDirectory]
        || [[NSFileManager defaultManager] fileExistsAtPath:@"/private/etc/ssh/sshd_config" isDirectory:&isDirectory]
        || [[NSFileManager defaultManager] fileExistsAtPath:@"/etc/ssh/sshd_config" isDirectory:&isDirectory]
        || [[NSFileManager defaultManager] fileExistsAtPath:@"/usr/libexec/ssh-keysign" isDirectory:&isDirectory]
        || [[NSFileManager defaultManager] fileExistsAtPath:@"/Applications/Snoop-it Config.app" isDirectory:&isDirectory]
        || [[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/xCon.dylib" isDirectory:&isDirectory]
        || [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"cydia://package/com.masbog.com"]]
        )
    {
        return false;
    }
    return true;
}

-(BOOL)checkRead
{
    FILE *f = nil;
    if ((f != fopen("/bin/bash", "r")) || (f != fopen("/bin/sh", "r")) || (f != fopen("/Applications/Cydia.app", "r")) || (f != fopen("/Library/MobileSubstrate/MobileSubstrate.dylib", "r")) || (f != fopen("/usr/sbin/sshd", "r")) || (f != fopen("/etc/apt", "r")))
    {
        fclose(f);
        return false;
    }
    fclose(f);
    return true;
}

-(BOOL)checkWrite
{
    FILE *f = nil;
    NSString *stringToBeWritten = @"Jail";
    NSError *err = nil;
    [stringToBeWritten writeToFile:@"/private/jail" atomically:true encoding:NSUTF8StringEncoding error:&err];
    [[NSFileManager defaultManager] removeItemAtPath:@"/private/jail" error:&err];
    fclose(f);
    if(err==nil)
    {
        return false;
    }
    return true;
}

+(BOOL)checkJail
{
    JailbreakDetection *j = [JailbreakDetection new];
    return [j checkFile]&&[j checkRead]&&[j checkWrite];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
