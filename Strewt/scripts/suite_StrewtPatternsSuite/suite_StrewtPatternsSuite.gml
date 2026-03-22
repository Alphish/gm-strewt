function StrewtPatternsSuite() : VerrificSuiteGroup("Strewt Patterns tests") constructor {
    array_foreach([
        StrewtNumberPatternTests,
        StrewtStringTerminatorDoublingPatternTests,
        StrewtStringCharacterEscapePatternTests,
    ], function(_test) {
        add_methods_from(_test);
    });
}
