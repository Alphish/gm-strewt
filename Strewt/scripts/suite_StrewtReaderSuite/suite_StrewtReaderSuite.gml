function StrewtReaderSuite() : VerrificSuiteGroup("Strewt Reader tests") constructor {
    array_foreach([
        StrewtReaderCreationTests,
        StrewtReaderPositionTests,
        StrewtReaderLocationTests,
        StrewtReaderSubstringTests,
        StrewtReaderTargetCopyTests,
        StrewtReaderNextByteTests,
        StrewtReaderSpecificByteTests,
        StrewtReaderByteSequenceTests,
        StrewtReaderCharacterTests,
        StrewtReaderDigraphTests,
        StrewtReaderTrigraphTests,
        StrewtReaderTetragraphTests,
        StrewtReaderStringTests,
        StrewtReaderLineTests,
        StrewtReaderCharsetTests,
        StrewtReaderCharsetStringTests,
        StrewtReaderChartableTests,
    ], function(_test) {
        add_methods_from(_test);
    });
}
