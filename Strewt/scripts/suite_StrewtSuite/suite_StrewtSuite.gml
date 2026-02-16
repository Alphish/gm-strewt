function StrewtSuite() : VerrificSuiteGroup("Strewt tests") constructor {
    add_suite(new StrewtChartableSuite());
    add_suite(new StrewtCharsetSuite());
    add_suite(new StrewtReaderSuite());
    add_suite(new StrewtPatternsSuite());
}
