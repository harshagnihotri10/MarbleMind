// Cell class to represent each grid cell
class Cell{
  String? marble; // Represents the player's marble ('X' or '0') or null if empty
  int row;
  int col;

  // Constructor
  Cell({this.marble, required this.row, required this.col});

  // Method to create a default cell instance
  static Cell defaultCell({required int row, required int col}) {
    return Cell(
      marble: null, // Default to no marble
      row: -1,      // Use -1 to indicate an invalid or undefined row
      col: -1,      // Use -1 to indicate an invalid or undefined column
    );
  }

  // Convert Cell object to a map (JSON format)
  Map<String, dynamic> toJson() {
    return {
      'marble': marble,
      'row': row,
      'col': col,
    };
  }

  // Convert a map (JSON) back into a Cell object
  factory Cell.fromJson(Map<String, dynamic> json) {
    assert(json.containsKey('row') && json.containsKey('col'),
      "Invalid JSON format for Cell: $json");
    return Cell(
      marble: json['marble'],
      row: json['row'],
      col: json['col'],
    );
  }
}