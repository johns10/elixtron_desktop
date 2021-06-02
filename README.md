# ElixtronDesktop

ElixtronDesktop is a small desktop application that starts, and accepts RPC commands that will open a local copy of chrome (see https://github.com/johns10/elixtron_desktop/blob/master/lib/server.ex, it's currently hardcoded to a windows path, with some startup args), connect to the running browser using https://github.com/andrewvy/chrome-remote-interface, and navigate to an address passed in on an arg.

This implementation is a little anemic with respect to Elixir Releases.  I didn't fully understand how to implement this with a production release, so I did it with the dev release.

Basically I made the dev build, and then hacked up the .bat file that launches the binary so it supported rpc calls in this form: elixtron ElixtronDesktop.open_browser().

You can find the hacked up batch file here: https://github.com/johns10/elixtron_desktop/blob/master/elixtron.bat.  There's probably a similar modification that could be made to the bash script.  I think one could do a production release, and make the default call "rpc," then install the binary as a daemon/service.  That's probably the most healthy production approach.  You should move this batch into your build directory `_build\dev\rel\demo\bin` (if you're on windows).

This is intended to be used with a custom protocol in conjunction with https://github.com/johns10/elixtron (a small LiveView project that calls the custom protocols).  

This is part of an Elixir Talk given at an ElixirTO event: https://www.meetup.com/TorontoElixir/events/278237262/.
