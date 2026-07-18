/// @desc The location data for a position within a text content.
/// @arg {Real} [line]                  The content line.
/// @arg {Real} [column]                The line column.
/// @arg {Real} [position]              The content byte position.
function StrewtLocation(_line = 1, _column = 1, _position = 0) constructor { 
    /// @desc The content line (1-indexed).
    /// @returns {Real}
    line = _line;
    
    /// @desc The line column (1-indexed).
    /// @returns {Real}
    column = _column;
    
    /// @desc The content byte position (0-indexed).
    /// @returns {Real}
    position = _position;
    
    static toString = function() {
        return $"Ln: {line} Col: {column} Pos: {position}";
    }
    
    /// @desc Creates a string describing the current line and column.
    /// @returns {String}
    static get_line_column = function() {
        return $"Ln: {line} Col: {column}";
    }
    
    /// @desc Creates a new location data instance with same coordinates.
    /// @returns {Struct.StrewtLocation}
    static clone = function() {
        return new StrewtLocation(line, column, position);
    }
}
