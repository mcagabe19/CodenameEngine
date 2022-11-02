package funkin.system;

import haxe.Log;
import funkin.windows.WindowsAPI;
import funkin.windows.WindowsAPI.ConsoleColor;

class Logs {
    private static var __showing:Bool = false;
    public static function init() {
        __showInConsole([
            logText("Hello, World! ", CYAN),
            logText("I am..."),
            logText("COLORED!!", RED)]);

        Log.trace = function(v : Dynamic, ?infos : Null<haxe.PosInfos>) {
            __showInConsole(prepareColoredTrace([
                logText('${infos.fileName}:${infos.lineNumber}: ', CYAN),
                logText(Std.string(v))
            ], TRACE));
        };
    }

    public static function prepareColoredTrace(text:Array<LogText>, level:Level = INFO) {
        var time = Date.now();
        var superCoolText = [
            logText('[ '),
            logText('${Std.string(time.getHours()).addZeros(2)}:${Std.string(time.getMinutes()).addZeros(2)}:${Std.string(time.getSeconds()).addZeros(2)}', DARKMAGENTA),
            logText(' |'),
            switch(level) {
                case WARNING:   logText('   WARNING   ', DARKYELLOW);
                case ERROR:     logText('    ERROR    ', DARKRED);
                case TRACE:     logText('    TRACE    ', GRAY);
                default:        logText(' INFORMATION ', CYAN);
            },
            logText('] ')
        ];
        for(k=>e in superCoolText)
            text.insert(k, e);
        return text;
    }

    public static function logText(text:String, color:ConsoleColor = LIGHTGRAY):LogText {
        return {
            text: text,
            color: color
        };
    }

    public static function __showInConsole(text:Array<LogText>) {
        #if sys
        while(__showing) {
            Sys.sleep(0.05);
        }
        __showing = true;
        for(t in text) {
            WindowsAPI.setConsoleColors(t.color);
            Sys.print(t.text);
        }
        WindowsAPI.setConsoleColors();
        Sys.print("\r\n");
        __showing = false;
        #else
        trace(text);
        #end
    }

    public static function traceColored(text:Array<LogText>, level:Level = INFO) {
        __showInConsole(prepareColoredTrace(text, level));
    }
    public static function trace(text:String, level:Level = INFO, color:ConsoleColor = LIGHTGRAY) {
        traceColored([{
            text: text,
            color: color
        }], level);
    }
}

enum abstract Level(Int) {
    var INFO = 0;
    var WARNING = 1;
    var ERROR = 2;
    var TRACE = 3;
}
typedef LogText = {
    var text:String;
    var color:ConsoleColor;
}