function TestDummyFormatter(_input) : StrewtFormatter(_input) constructor {
    current_item = 0;
    total_items = array_length(input);
    header = undefined;
    
    static process_step = function() {
        if (status != 0)
            return;
        
        if (total_items == 0)
            return complete();
        
        switch (input[current_item]) {
            case ">":
                writer.push_indent();
                break;
            case "<":
                writer.pop_indent();
                break;
            case "?":
                return fail("Cannot process individual question marks.");
            default:
                writer.write_line(input[current_item]);
                break;
        }
        current_item += 1;
        
        return complete_when(current_item >= total_items);
    }
    
    static get_progress = function() {
        return $"{current_item}/{total_items}";
    }
}
