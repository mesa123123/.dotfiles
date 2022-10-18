import { ExpressionBuilderResult, LanguageName, ParameterTypeMeta, ParserAdapter, Source } from './types.js';
export declare class ExpressionBuilder {
    private readonly parserAdapter;
    constructor(parserAdapter: ParserAdapter);
    build(sources: readonly Source<LanguageName>[], parameterTypes: readonly ParameterTypeMeta[]): ExpressionBuilderResult;
}
//# sourceMappingURL=ExpressionBuilder.d.ts.map