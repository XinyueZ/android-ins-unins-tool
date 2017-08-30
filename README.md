# android-ins-unins-tool

A commond wrapper on ```adb``` command to support install or uninstall multi-Apks.

# Why

- The ```adb``` doesn't support multi-Apks at moment.
- The ```.gradlew uninstall/install``` is slow, too slow. When you run it, the gradle must download something.
- Other tools ? Not found yet.

# Run

> Uninstall Apks

- On all devices

```ruby uninstallapp.rb --all com.name.apk```

- On selected devices with id, i.e 234524

```ruby uninstallapp.rb 234524 4534524 35345 com.name.apk```

> Install Apks(from file)

- On all devices

```ruby installapp.rb --all ../../Desktop/name.apk```

- On Selected devices with id, i.e 234524

```ruby installapp.rb 234524 4534524 35345 ../../Desktop/name.apk```



# Known issues

- For hight level versions of Android, you'll see errors like this when you run the command. It is *OK* because the ```adb``` can't find Apks and dump these out. This happens just on some devices like *Pixel XL* etc.

```
Exception occurred while dumping:
java.lang.IllegalArgumentException: Unknown package: adfasdf.asdffasdf.com
        at com.android.server.pm.Settings.isOrphaned(Settings.java:4134)
        at com.android.server.pm.PackageManagerService.isOrphaned(PackageManagerService.java:18150)
        at com.android.server.pm.PackageManagerService.deletePackage(PackageManagerService.java:15567)
        at com.android.server.pm.PackageInstallerService.uninstall(PackageInstallerService.java:888)
        at com.android.server.pm.PackageManagerShellCommand.runUninstall(PackageManagerShellCommand.java:792)
        at com.android.server.pm.PackageManagerShellCommand.onCommand(PackageManagerShellCommand.java:118)
        at android.os.ShellCommand.exec(ShellCommand.java:94)
        at com.android.server.pm.PackageManagerService.onShellCommand(PackageManagerService.java:18408)
        at android.os.Binder.shellCommand(Binder.java:468)
        at android.os.Binder.onTransact(Binder.java:367)
        at android.content.pm.IPackageManager$Stub.onTransact(IPackageManager.java:2387)
        at com.android.server.pm.PackageManagerService.onTransact(PackageManagerService.java:3048)
        at android.os.Binder.execTransact(Binder.java:565)
```

- Normal output when Apks can't be found after  running command you'll see output like this

```
@Tool@: It is a real package: asdfasdf.asdfasdf.com
@Tool@: Find devices:["ce051715d931181103"]
@Tool@: Removed asdfsdf.asdfadsf.com on ce051715d931181103
@Tool@: Failure [DELETE_FAILED_INTERNAL_ERROR]
```

- When all successful, you'll see

```
@Tool@: It is a real package: afasdf.asdfasdf.com
@Tool@: Find devices:["ce051715d931181103"]
@Tool@: Removed asdfasdf.asdfasdf.com on ce051715d931181103
@Tool@: Success
````

# License

The MIT License (MIT)

Copyright (c) 2017 Chris Xinyue Zhao

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

