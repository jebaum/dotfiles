#!/usr/bin/env gjs

// requires i3ipc-gjs aur package

var i3ipc = imports.gi.i3ipc; // const!
var conn = new i3ipc.Connection();
var bar0conf = conn.get_bar_config('bar-0');

// for (var p in bar0conf)
    // print(p + ': ' + bar0conf[p]);

if (bar0conf.mode == "dock") {
    conn.command('bar mode invisible');
}
else {
    conn.command('bar mode dock');
}
