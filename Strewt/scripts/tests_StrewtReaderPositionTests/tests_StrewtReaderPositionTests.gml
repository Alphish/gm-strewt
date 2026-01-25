function StrewtReaderPositionTests(_run, _method) : StrewtReaderBaseTests(_run, _method) constructor {
    static test_subject = "Reader position";
    
    static should_start_with_zero_position = function() {
        given_content("Hello, world!");
        assert_equal(0, reader.get_position());
        assert_equal(0, buffer_tell(reader.content_buffer));
    }
    
    static should_jump_to_given_positions = function() {
        given_content("Hello, world!");
        assert_equal(0, reader.get_position());
        assert_equal(0, buffer_tell(reader.content_buffer));
        
        reader.move_to(8);
        assert_equal(8, reader.get_position());
        assert_equal(8, buffer_tell(reader.content_buffer));
        
        reader.move_to(3);
        assert_equal(3, reader.get_position());
        assert_equal(3, buffer_tell(reader.content_buffer));
    }
    
    static should_move_position_by_given_offset = function() {
        given_content("Hello, world!");
        assert_equal(0, reader.get_position());
        assert_equal(0, buffer_tell(reader.content_buffer));
        
        reader.move_by(8);
        assert_equal(8, reader.get_position());
        assert_equal(8, buffer_tell(reader.content_buffer));
        
        reader.move_by(-5);
        assert_equal(3, reader.get_position());
        assert_equal(3, buffer_tell(reader.content_buffer));
    }
    
    static should_correctly_report_end_of_string = function() {
        given_content("Hello, world!");
        assert_equal(false, reader.is_end_of_string());
        
        reader.move_to(12);
        assert_equal(false, reader.is_end_of_string());
        
        reader.move_to(13);
        assert_equal(true, reader.is_end_of_string());
    }
}
