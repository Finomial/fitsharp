// Copyright � 2018 Syterra Software Inc. All rights reserved.
// The use and distribution terms for this software are covered by the Common Public License 1.0 (http://opensource.org/licenses/cpl.php)
// which can be found in the file license.txt at the root of this distribution. By using this software in any fashion, you are agreeing
// to be bound by the terms of this license. You must not remove this notice, or any other, from this software.

using System.Diagnostics;

namespace fitSharp.Test.Acceptance {
    public class FitNesseStory {
        public void Run(string suite) {
            var startInfo = new ProcessStartInfo("java",
#if NETCOREAPP2_0
                "\"-DTEST_RUNNER=dotnet build\\sandbox\\Runner.dll\""
#else
                "\"-DTEST_RUNNER=build\\sandbox\\Runner.exe\""
#endif
                + " -jar .\\binary\\tools\\fitnesse\\fitnesse.jar -o -d .\\document -r FitnesseRoot -c \"" + suite +
                "?suite&format=text\"") {
                UseShellExecute = false,
                RedirectStandardOutput = true
            };
            process = Process.Start(startInfo);
            process.WaitForExit();
        }

        public string StandardOutput => process.StandardOutput.ReadToEnd();

        Process process;
    }
}
