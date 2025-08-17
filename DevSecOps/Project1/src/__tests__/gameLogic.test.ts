import { describe, it, expect } from 'vitest';
import { calculateWinner, checkDraw } from '../utils/gameLogic';

describe('Game Logic', () => {
  describe('calculateWinner', () => {
    it('should return null when there is no winner', () => {
      const board = [null, null, null, null, null, null, null, null, null];
      expect(calculateWinner(board)).toBeNull();
    });

    it('should detect horizontal win for X', () => {
      const board = ['X', 'X', 'X', null, 'O', 'O', null, null, null];
      const result = calculateWinner(board);
      expect(result).not.toBeNull();
      expect(result?.winner).toBe('X');
      expect(result?.line).toEqual([0, 1, 2]);
    });

    it('should detect vertical win for O', () => {
      const board = ['X', 'O', 'X', null, 'O', 'X', null, 'O', null];
      const result = calculateWinner(board);
      expect(result).not.toBeNull();
      expect(result?.winner).toBe('O');
      expect(result?.line).toEqual([1, 4, 7]);
    });

    it('should detect diagonal win', () => {
      const board = ['X', 'O', 'O', null, 'X', 'O', null, null, 'X'];
      const result = calculateWinner(board);
      expect(result).not.toBeNull();
      expect(result?.winner).toBe('X');
      expect(result?.line).toEqual([0, 4, 8]);
    });
  });

  describe('checkDraw', () => {
    it('should return false when board is not full', () => {
      const board = ['X', 'O', 'X', 'O', null, 'X', 'O', 'X', 'O'];
      expect(checkDraw(board)).toBe(false);
    });

    it('should return false when there is a winner', () => {
      const board = ['X', 'X', 'X', 'O', 'O', null, null, null, null];
      expect(checkDraw(board)).toBe(false);
    });

    it('should return true when board is full with no winner', () => {
      const board = ['X', 'O', 'X', 'X', 'O', 'O', 'O', 'X', 'X'];
      expect(checkDraw(board)).toBe(true);
    });
  });
});