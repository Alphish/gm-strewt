function StrewtReaderSuite() : VerrificSuiteGroup("Strewt Reader tests") constructor {
    array_foreach([
        StrewtReaderCreationTests,
        StrewtReaderPositionTests,
        StrewtReaderSubstringTests,
        StrewtReaderCharsetTests,
        StrewtReaderCharsetStringTests,
    ], function(_test) {
        add_methods_from(_test);
    });
}
