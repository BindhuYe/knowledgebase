import React from 'react';
import { History, Clock } from 'lucide-react';

interface GameHistoryProps {
  history: Array<{
    winner: string | null;
    board: Array<string | null>;
    date: Date;
  }>;
}

const GameHistory: React.FC<GameHistoryProps> = ({ history }) => {
  // Format date to a readable string
  const formatDate = (date: Date) => {
    return new Intl.DateTimeFormat('en-US', {
      hour: '2-digit',
      minute: '2-digit',
      second: '2-digit',
    }).format(date);
  };

  // Get result text based on winner
  const getResultText = (winner: string | null) => {
    if (winner) {
      return `Player ${winner} won`;
    }
    return "Draw";
  };

  // Get appropriate color class based on winner
  const getResultColorClass = (winner: string | null) => {
    if (winner === 'X') return 'text-indigo-600';
    if (winner === 'O') return 'text-purple-600';
    return 'text-gray-600';
  };

  return (
    <div className="bg-gray-50 p-4 rounded-lg border border-gray-200">
      <h2 className="text-lg font-semibold text-gray-800 mb-3 flex items-center gap-2">
        <History className="h-5 w-5 text-blue-500" />
        Game History
      </h2>
      
      <div className="max-h-60 overflow-y-auto space-y-2 pr-1">
        {history.length === 0 ? (
          <p className="text-gray-500 text-sm italic">No games played yet</p>
        ) : (
          [...history].reverse().map((game, index) => (
            <div key={index} className="p-2 bg-white rounded border border-gray-200 text-sm">
              <div className="flex justify-between items-center mb-1">
                <span className={`font-medium ${getResultColorClass(game.winner)}`}>
                  {getResultText(game.winner)}
                </span>
                <span className="text-gray-500 flex items-center gap-1">
                  <Clock className="h-3 w-3" />
                  {formatDate(game.date)}
                </span>
              </div>
            </div>
          ))
        )}
      </div>
    </div>
  );
};

export default GameHistory;