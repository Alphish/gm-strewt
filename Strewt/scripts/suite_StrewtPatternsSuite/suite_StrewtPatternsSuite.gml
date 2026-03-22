function StrewtPatternsSuite() : VerrificSuiteGroup("Strewt Patterns tests") constructor {
    array_foreach([
        StrewtNumberPatternTests,
        StrewtStringTerminatorDoublingPatternTests,
    ], function(_test) {
        add_methods_from(_test);
    });
}
