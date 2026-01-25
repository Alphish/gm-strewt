function StrewtCharsetSuite() : VerrificSuiteGroup("Strewt Charset tests") constructor {
    array_foreach([
        StrewtCharsetCreationTests,
        StrewtCharsetSettingTests,
        StrewtCharsetRangeTests,
        StrewtCharsetDerivedTests,
    ], function(_test) {
        add_methods_from(_test);
    });
}
