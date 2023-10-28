# tadpole

An app to track frog growth cycles :).

## Getting Started

1. Fork and clone tadpole with Git Bash or other preferred git interface
1. Download flutter from [here](https://docs.flutter.dev/get-started/install/windows)
1. Extract the zip file and save it somewhere you will remember
1. Add flutter to your Path
    1. Find the program System Properties -> Environment Variables (should be a button near the bottom)
    1. Under User variables check if there is an entry called Path
        1. If the entry exists, click on it, click new and add the full path to flutter\bin (i.e. if it was saved under D:\dev\flutter you will save D:\dev\flutter\bin)
        1. If the entry doesn’t exist, create a new user variable named Path with the full path to flutter\bin as its value
1. To check the above went correctly, run "where flutter dart" (no quotation marks) in your terminal. If it returns nothing, try where.exe flutter dart.
    1. This should return several lines that repeat your flutter path (i.e. D:\dev\flutter\bin) followed by \flutter, \dart, \flutter.bat, and \dart.bat.
1. Download [Android Studio](https://developer.android.com/studio).
1. Inside Android Studio, open the tadpole project.
1. Open Tools -> SDKManager. Click SDK Tools, then click the checkbox next to Android SDK Command-line Tools(latest) and hit OK. This will [download the command-line tools for you](https://stackoverflow.com/questions/68236007/i-am-getting-error-cmdline-tools-component-is-missing-after-installing-flutter).
1. Download [Google Chrome](https://www.google.com/chrome/).
1. Download [Visual Studio Community Version](https://visualstudio.microsoft.com/downloads/). When prompted in the installation process, select the Desktop development with C++ workload.
1. In Visual Studio Code, load the tadpole project then in the terminal, run the command "flutter run" (no quotations).
    1. If you are prompted, run the command "start ms-settings: developers" (no quotations), then turn on Developer Mode under the Privacy & security -> For developers settings.
1. In Visual Studio Code terminal, run the command "flutter doctor". At this point, you may be promoted to run "flutter doctor --android-licenses" (no quotations).
    1. If prompted, run "flutter doctor --android-licenses" (no quotations). Reply "y" (no quotations) to the option to Review licenses that have not been accepted, and accept all.
1. Re-run "flutter doctor" (no quotations). At this point, you should receive all green checkmarks (please do not @ me if you are red/green colorblind).
1. Re-run "flutter run" (no quotations). The project should start.
    1. If this is not the case, return to the Path variable from step 4ii.
        1. Add the path to the git executable (i.e. if Git is stored at D:\dev\Git, add D:\dev\Git\bin\git.exe).
        1. Add the path to the git command folder (i.e. if Git is stored at D:\dev\Git, add D:\dev\Git\cmd).
        1. Add the path to the Windows system (i.e. C:\Windows\System32).