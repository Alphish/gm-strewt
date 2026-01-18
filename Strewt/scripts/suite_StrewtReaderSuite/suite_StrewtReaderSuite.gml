function StrewtReaderSuite() : VerrificSuiteGroup("Strewt Reader tests") constructor {
    array_foreach([
        StrewtReaderCreationTests,
        StrewtReaderPositionTests,
        StrewtReaderSubstringTests,
    ], function(_test) {
        add_methods_from(_test);
    });
}
