import React from 'react';
import Square from './Square';

interface BoardProps {
  squares: Array<string | null>;
  onClick: (i: number) => void;
  winningLine: number[] | null;
}

const Board: React.FC<BoardProps> = ({ squares, onClick, winningLine }) => {
  const renderSquare = (i: number) => {
    const isWinningSquare = winningLine?.includes(i) || false;
    
    return (
      <Square
        value={squares[i]}
        onClick={() => onClick(i)}
        isWinningSquare={isWinningSquare}
      />
    );
  };

  return (
    <div className="grid grid-cols-3 gap-2 w-full max-w-xs">
      {Array(9).fill(null).map((_, i) => (
        <div key={i}>
          {renderSquare(i)}
        </div>
      ))}
    </div>
  );
};

export default Board;