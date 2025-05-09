/**
 * Calculate the winner of a tic-tac-toe game
 * @param squares The current state of the board
 * @returns The winner and winning line, or null if no winner
 */
export function calculateWinner(squares: Array<string | null>) {
  // All possible winning lines (rows, columns, diagonals)
  const lines = [
    [0, 1, 2], // top row
    [3, 4, 5], // middle row
    [6, 7, 8], // bottom row
    [0, 3, 6], // left column
    [1, 4, 7], // middle column
    [2, 5, 8], // right column
    [0, 4, 8], // diagonal top-left to bottom-right
    [2, 4, 6], // diagonal top-right to bottom-left
  ];

  // Check each winning line
  for (const [a, b, c] of lines) {
    if (squares[a] && squares[a] === squares[b] && squares[a] === squares[c]) {
      return {
        winner: squares[a],
        line: [a, b, c]
      };
    }
  }

  return null;
}

/**
 * Check if the game is a draw
 * @param squares The current state of the board
 * @returns True if the game is a draw, false otherwise
 */
export function checkDraw(squares: Array<string | null>): boolean {
  // If there's a winner, it's not a draw
  if (calculateWinner(squares)) {
    return false;
  }
  
  // If all squares are filled, it's a draw
  return squares.every(square => square !== null);
}