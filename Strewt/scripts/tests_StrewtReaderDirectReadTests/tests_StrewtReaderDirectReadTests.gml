function StrewtReaderDirectReadTests(_run, _method) : StrewtReaderMethodFamilyBaseTests(_run, _method) constructor {
    static test_subject = "Direct reading";
    
    // -----
    // Setup
    // -----
    
    datatype = undefined;
    static given_datatype = function(_datatype) {
        datatype = strewt_digraph(_datatype);
    }
    
    static when_spanned = function() {
        return undefined;
    }
    
    static when_skipped = function() {
        return undefined;
    }
    
    static when_peeked = function() {
        return reader.peek_direct(datatype);
    }
    
    static when_read = function() {
        return reader.read_direct(datatype);
    }
    
    static when_read_into_target = function(_target) {
        return undefined;
    }
    
    // -----
    // Tests
    // -----
    
    static should_read_byte_directly = function() {
        var _buffer = buffer_create(4, buffer_fixed, 1);
        buffer_write(_buffer, buffer_u8, 12);
        buffer_write(_buffer, buffer_u8, 34);
        buffer_write(_buffer, buffer_u8, 56);
        buffer_write(_buffer, buffer_u8, 78);
        given_content(_buffer);
        given_datatype(buffer_u8);
        when_method_family_tested();
        
        then_expect_number(12);
        then_expect_positions(0, 1);
    }
    
    static should_read_short_integer_directly = function() {
        var _buffer = buffer_create(8, buffer_fixed, 1);
        buffer_write(_buffer, buffer_u16, 1234);
        buffer_write(_buffer, buffer_u16, 2345);
        buffer_write(_buffer, buffer_u16, 3456);
        buffer_write(_buffer, buffer_u16, 4567);
        given_content(_buffer);
        given_datatype(buffer_u16);
        when_method_family_tested();
        
        then_expect_number(1234);
        then_expect_positions(0, 2);
    }
    
    static should_read_basic_integer_directly = function() {
        var _buffer = buffer_create(8, buffer_fixed, 1);
        buffer_write(_buffer, buffer_u32, 123456);
        buffer_write(_buffer, buffer_u32, 234567);
        buffer_write(_buffer, buffer_u32, 345678);
        buffer_write(_buffer, buffer_u32, 456789);
        given_content(_buffer);
        given_datatype(buffer_u32);
        when_method_family_tested();
        
        then_expect_number(123456);
        then_expect_positions(0, 4);
    }
}
