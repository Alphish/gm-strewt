function StrewtReaderBaseTests(_run, _method) : VerrificMethodTest(_run, _method) constructor {
    reader = undefined;
    
    static given_content = function(_content) {
        reader = new StrewtReader(_content);
    }
    
    static test_cleanup = function() {
        if (!is_undefined(reader))
            reader.cleanup();
    }
}
