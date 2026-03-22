# TODO

## Module deduplication - test coverage

The module deduplication feature currently applies to all files processed by `compile_file()`.
The following keyword-specific scenarios need dedicated test fixtures and verification:

- [ ] `public` - Two modules exposing the same public submodule (shared submodule included once)
- [ ] `embed` - Two files embedding the same module (embedded function generated once)
- [ ] `legacy` - Two files importing the same legacy module (legacy code included once)
- [ ] `extern package` - Two files declaring the same extern package (package code included once)


mush add name_convention@develop --dev