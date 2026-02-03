function StrewtChartableSuite() : VerrificSuiteGroup("Strewt Chartable tests") constructor {
    array_foreach([
        StrewtChartableCreationTests,
        StrewtChartableCloneTests,
        StrewtChartableRangeTests,
        StrewtChartableSettingTests,
    ], function(_test) {
        add_methods_from(_test);
    });
}
