function StrewtWriterSuite() : VerrificSuiteGroup("Strewt Writer tests") constructor {
    array_foreach([
        StrewtWriterCreationTests,
        StrewtWriterPositionTests,
        StrewtWriterValueWritingTests,
        StrewtWriterLineWritingTests,
        StrewtWriterMultilineWritingTests,
        StrewtWriterDirectWritingTests,
        StrewtWriterIndentTests,
    ], function(_test) {
        add_methods_from(_test);
    });
}
