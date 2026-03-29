function StrewtLocation(_line = 1, _column = 1, _position = 0) constructor {
    line = _line;
    column = _column;
    position = _position;
    
    static toString = function() {
        return $"Ln: {line} Col: {column} Pos: {position}";
    }
    
    static get_line_column = function() {
        return $"Ln: {line} Col: {column}";
    }
}
