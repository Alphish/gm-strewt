function StrewtReaderSuite() : VerrificSuiteGroup("Strewt Reader tests") constructor {
    array_foreach([
        StrewtReaderCreationTests,
        StrewtReaderPositionTests,
        StrewtReaderSubstringTests,
        StrewtReaderTargetCopyTests,
        StrewtReaderByteTests,
        StrewtReaderSpecificByteTests,
        StrewtReaderByteSequenceTests,
        StrewtReaderCharacterTests,
        StrewtReaderMultigraphTests,
        StrewtReaderStringTests,
        StrewtReaderLineTests,
        StrewtReaderCharsetTests,
        StrewtReaderCharsetStringTests,
        StrewtReaderChartableTests,
        StrewtReaderPatternTests,
    ], function(_test) {
        add_methods_from(_test);
    });
}
