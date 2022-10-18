import { Suggestion } from '../suggestions/types.js';
import { Index } from './types';
/**
 * A brute force (not very performant or fuzzy-search capable) index that matches permutation expressions with string.includes()
 *
 * @param suggestions
 */
export declare function bruteForceIndex(suggestions: readonly Suggestion[]): Index;
//# sourceMappingURL=bruteForceIndex.d.ts.map