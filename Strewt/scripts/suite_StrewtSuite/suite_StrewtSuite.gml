function StrewtSuite() : VerrificSuiteGroup("Strewt tests") constructor {
    add_suite(new StrewtCharsetSuite());
    add_suite(new StrewtReaderSuite());
}
