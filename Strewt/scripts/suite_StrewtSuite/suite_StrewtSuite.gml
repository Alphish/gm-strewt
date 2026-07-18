function StrewtSuite() : VerrificSuiteGroup("Strewt tests") constructor {
    add_methods_from(StrewtMultigraphTests);
    add_suite(new StrewtChartableSuite());
    add_suite(new StrewtCharsetSuite());
    add_methods_from(StrewtLocationTests);
    add_suite(new StrewtReaderSuite());
    add_suite(new StrewtPatternsSuite());
    add_suite(new StrewtParserSuite());
    add_suite(new StrewtWriterSuite());
}
