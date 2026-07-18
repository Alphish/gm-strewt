function StrewtFormatterSuite() : VerrificSuiteGroup("Strewt Formatter tests") constructor {
    array_foreach([
        StrewtFormatterCoreTests,
        StrewtFormatterOptionsTests,
        StrewtFormatterTaskTests,
    ], function(_test) {
        add_methods_from(_test);
    });
}
