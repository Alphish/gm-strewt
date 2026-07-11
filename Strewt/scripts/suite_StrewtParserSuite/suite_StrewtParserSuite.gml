function StrewtParserSuite() : VerrificSuiteGroup("Strewt Parser tests") constructor {
    array_foreach([
        StrewtParserCoreTests,
        StrewtParserFileTests,
        StrewtParserOptionsTests,
        StrewtParserTaskTests,
    ], function(_test) {
        add_methods_from(_test);
    });
}
