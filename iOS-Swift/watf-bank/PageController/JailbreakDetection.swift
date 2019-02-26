import UIKit

class JailbreakDetection : UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        if(isJail()) {
            if let token = KeyChain.load("token") {
                if token != "" {
                    Util.changeView(self,"Pin")
                }
            }
            else {
                Util.changeView(self,"Login")
            }
        }
        else {
            Util.changeView(self, "Jailbreak")
        }
    }
    
    func isJail() -> Bool {
        return checkFile() || checkRead() || checkWrite()
    }
    
    func checkFile() -> Bool {
        var isDirectory: ObjCBool = ObjCBool(false)
        if (FileManager.default.fileExists(atPath: "/Applications/Cydia.app")
            || FileManager.default.fileExists(atPath: "/Applications/blackra1n.app")
            || FileManager.default.fileExists(atPath: "/Applications/FakeCarrier.app")
            || FileManager.default.fileExists(atPath: "/Applications/Icy.app")
            || FileManager.default.fileExists(atPath: "/Applications/IntelliScreen.app")
            || FileManager.default.fileExists(atPath: "/Applications/MxTube.app")
            || FileManager.default.fileExists(atPath: "/Applications/RockApp.app")
            || FileManager.default.fileExists(atPath: "/Applications/SBSetttings.app")
            || FileManager.default.fileExists(atPath: "/Applications/WinterBoard.app")
            || FileManager.default.fileExists(atPath: "/private/var/lib/apt/", isDirectory: &isDirectory)
            || FileManager.default.fileExists(atPath: "/private/var/lib/cydia/", isDirectory: &isDirectory)
            || FileManager.default.fileExists(atPath: "/private/var/mobileLibrary/SBSettingsThemes/", isDirectory: &isDirectory)
            || FileManager.default.fileExists(atPath: "/private/var/tmp/cydia.log")
            || FileManager.default.fileExists(atPath: "/private/var/stash/", isDirectory: &isDirectory)
            || FileManager.default.fileExists(atPath: "/usr/libexec/cydia/", isDirectory: &isDirectory)
            || FileManager.default.fileExists(atPath: "/usr/binsshd")
            || FileManager.default.fileExists(atPath: "/usr/sbinsshd")
            || FileManager.default.fileExists(atPath: "/usr/libexec/cydia/", isDirectory: &isDirectory)
            || FileManager.default.fileExists(atPath: "/usr/libexec/sftp-server")
            || FileManager.default.fileExists(atPath: "/Systetem/Library/LaunchDaemons/com.ikey.bbot.plist")
            || FileManager.default.fileExists(atPath: "/System/Library/LaunchDaemons/com.saurik.Cy@dia.Startup.plist")
            || FileManager.default.fileExists(atPath: "/Library/MobileSubstrate/MobileSubstrate.dylib")
            || FileManager.default.fileExists(atPath: "/var/cache/apt/", isDirectory: &isDirectory)
            || FileManager.default.fileExists(atPath: "/var/lib/apt/", isDirectory: &isDirectory)
            || FileManager.default.fileExists(atPath: "/var/lib/cydia/", isDirectory: &isDirectory)
            || FileManager.default.fileExists(atPath: "/var/log/syslog")
            || FileManager.default.fileExists(atPath: "/private/var/cache/apt/", isDirectory: &isDirectory)
            || FileManager.default.fileExists(atPath: "/private/var/lib/apt/", isDirectory: &isDirectory)
            || FileManager.default.fileExists(atPath: "/private/var/lib/cydia/", isDirectory: &isDirectory)
            || FileManager.default.fileExists(atPath: "/private/var/log/syslog")
            || FileManager.default.fileExists(atPath: "/bin/bash")
            || FileManager.default.fileExists(atPath: "/bin/sh")
            || FileManager.default.fileExists(atPath: "/private/etc/apt/", isDirectory: &isDirectory)
            || FileManager.default.fileExists(atPath: "/etc/apt/", isDirectory: &isDirectory)
            || FileManager.default.fileExists(atPath: "/private/etc/ssh/sshd_config")
            || FileManager.default.fileExists(atPath: "/etc/ssh/sshd_config")
            || FileManager.default.fileExists(atPath: "/usr/libexec/ssh-keysign")
            || UIApplication.shared.canOpenURL(URL(string: "cydia://package/com.masbog.com")!) as Bool
            || FileManager.default.fileExists(atPath: "/Applications/Snoop-it/Config.app")
            || FileManager.default.fileExists(atPath: "/Library/MobileSubstrate/DynamicLibraries/ xCon.dylib")
            || FileManager.default.fileExists(atPath: "/private/etc/dpkg/origins/debian")
            ) {
            return true
        }
        return false
    }
    
    func checkRead() -> Bool {
        let f: UnsafeMutablePointer<FILE>! = nil
        if (f != fopen("/bin/bash", "r")) || (f != fopen("/bin/sh", "r")) || (f != fopen("/Applications/Cydia.app", "r")) || (f != fopen("/Library/MobileSubstrate/MobileSubstrate.dylib", "r")) || (f != fopen("/usr/sbin/sshd", "r")) || (f != fopen("/etc/apt", "r")) {
            fclose(f)
            return true
        }
        fclose(f)
        return false;
    }
    
    func checkWrite() -> Bool {
        let stringToBeWritten = "JailIsComingForYou"
        do {
            try stringToBeWritten.write(toFile: "/private/jail", atomically: true, encoding: String.Encoding.utf8)
            try FileManager.default.removeItem(atPath: "/private/jail")
        }
        catch {
            return false
        }
        return true
    }
}
