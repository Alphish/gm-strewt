function StrewtReaderSuite() : VerrificSuiteGroup("Strewt Reader tests") constructor {
    array_foreach([
        StrewtReaderCreationTests,
        StrewtReaderPositionTests,
        StrewtReaderSubstringTests,
        StrewtReaderByteTests,
        StrewtReaderByteSequenceTests,
        StrewtReaderCharacterTests,
        StrewtReaderCharsetTests,
        StrewtReaderCharsetStringTests,
    ], function(_test) {
        add_methods_from(_test);
    });
}
