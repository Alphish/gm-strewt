function StrewtPatternsSuite() : VerrificSuiteGroup("Strewt Patterns tests") constructor {
    array_foreach([
        StrewtNumberPatternTests,
    ], function(_test) {
        add_methods_from(_test);
    });
}
