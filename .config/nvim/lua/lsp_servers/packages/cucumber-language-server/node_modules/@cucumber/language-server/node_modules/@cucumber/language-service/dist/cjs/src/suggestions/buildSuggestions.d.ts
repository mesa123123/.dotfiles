import { Expression, ParameterTypeRegistry } from '@cucumber/cucumber-expressions';
import { Suggestion } from './types.js';
/**
 * Builds an array of {@link Suggestion} from steps and step definitions.
 *
 * @param registry
 * @param stepTexts
 * @param expressions
 * @param maxChoices
 */
export declare function buildSuggestions(registry: ParameterTypeRegistry, stepTexts: readonly string[], expressions: readonly Expression[], maxChoices?: number): readonly Suggestion[];
//# sourceMappingURL=buildSuggestions.d.ts.map