# Contributing to Portfolio Web

Thank you for considering contributing! While this is a personal portfolio project, contributions that improve code quality, accessibility, or performance are welcome.

## Getting Started

### Prerequisites

- [Flutter](https://flutter.dev/docs/get-started/install) (managed via [FVM](https://fvm.app/))
- A modern browser (Chrome recommended for development)

### Setup

```bash
git clone https://github.com/harshsureja/portfolio_web.git
cd portfolio_web
fvm flutter pub get
fvm flutter run -d chrome
```

> **Important:** Always use `fvm flutter` instead of bare `flutter` commands.

## Development Workflow

1. **Fork** the repository
2. Create a **feature branch** from `main`:
   ```bash
   git checkout -b feat/your-feature-name
   ```
3. Make your changes following the conventions below
4. **Analyze** your code:
   ```bash
   fvm flutter analyze
   ```
5. **Test** your changes:
   ```bash
   fvm flutter test
   ```
6. **Commit** using [Conventional Commits](https://www.conventionalcommits.org/):
   ```
   feat(scope): add new feature
   fix(scope): resolve bug
   docs: update documentation
   refactor(scope): restructure code
   test(scope): add tests
   ci: update CI/CD
   perf(scope): improve performance
   chore: maintenance tasks
   ```
7. Push and open a **Pull Request**

## Code Conventions

### Architecture
- Follow **Clean Architecture** (Presentation ← Domain → Data)
- New features go in `lib/features/<feature_name>/`
- Shared code goes in `lib/core/`

### Dart Style
- Use **absolute imports** (`package:portfolio_web/...`)
- Never hardcode colors — use `AppColors` / `Theme.of(context)`
- Never hardcode text styles — use `Theme.of(context).textTheme`
- Keep files under 300 lines; refactor if larger

### Accessibility
- Add `Semantics` labels to all interactive elements
- Support keyboard navigation
- Respect `prefers-reduced-motion`

### Testing
- Unit tests for controllers and services
- Widget tests for reusable components
- Run `fvm flutter test` before submitting

## Reporting Issues

If you find a bug or have a suggestion, please [open an issue](https://github.com/harshsureja/portfolio_web/issues/new/choose) with as much detail as possible.

## License

By contributing, you agree that your contributions will be licensed under the project's [MIT License](LICENSE).
