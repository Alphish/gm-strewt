function StrewtWriterPositionTests(_run, _method) : StrewtWriterBaseTests(_run, _method) constructor {
    static test_subject = "Writer position";
    
    static should_start_with_zero_position = function() {
        given_writer();
        expect_position(0);
    }
    
    static should_jump_to_given_positions = function() {
        given_writer();
        writer.write("Lorem ipsum");
        
        writer.move_to(7);
        expect_position(7);
        writer.move_to(3);
        expect_position(3);
        writer.move_to(99);
        expect_position(99);
    }
    
    static should_move_position_by_given_offset = function() {
        given_writer();
        writer.write("Lorem ipsum");
        
        writer.move_by(-5);
        expect_position(6); // moving from 11 to 6
        writer.move_by(-3);
        expect_position(3);
        writer.move_by(10);
        expect_position(13);
    }
    
    static should_overwrite_from_position = function() {
        given_writer();
        
        writer.write("Hello, world!");
        when_content_collected();
        expect_result("Hello, world!");
        
        writer.move_to(5);
        when_content_collected();
        expect_result("Hello");
        
        writer.write("!");
        when_content_collected();
        expect_result("Hello!");
    }
}
