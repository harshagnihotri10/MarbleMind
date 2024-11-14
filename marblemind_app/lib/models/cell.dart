// Cell class to represent each grid cell
class Cell{
  String? marble; // Represents the player's marble ('X' or '0') or null if empty
  int row;
  int col;

  Cell({this.marble, required this.row, required this.col});
}