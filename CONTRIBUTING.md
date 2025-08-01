# Contributing to Flutter Ecommerce App

Thank you for your interest in contributing to the Flutter Ecommerce App! This document provides guidelines and information for contributors.

## 🤝 How to Contribute

### Reporting Bugs

1. **Check existing issues** to see if the bug has already been reported
2. **Create a new issue** with a clear and descriptive title
3. **Use the bug report template** and provide:
   - A clear description of the problem
   - Steps to reproduce the issue
   - Expected vs actual behavior
   - Screenshots or videos if applicable
   - Device/OS information
   - Flutter version

### Suggesting Enhancements

1. **Check existing issues** to see if the feature has already been suggested
2. **Create a new issue** with the enhancement label
3. **Describe the feature** and its benefits
4. **Provide mockups or examples** if possible

### Code Contributions

#### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Git
- A code editor (VS Code, Android Studio, etc.)

#### Getting Started

1. **Fork the repository**
2. **Clone your fork**:
   ```bash
   git clone https://github.com/yourusername/flutter-ecommerce-app.git
   cd flutter-ecommerce-app
   ```

3. **Create a feature branch**:
   ```bash
   git checkout -b feature/your-feature-name
   ```

4. **Set up the development environment**:
   ```bash
   flutter pub get
   cp .example.env .env
   # Edit .env with your configuration
   # ⚠️ IMPORTANT: All environment variables are required
   # The app will fail to start if any value is missing
   ```

5. **Make your changes** following the coding standards below

6. **Test your changes**:
   ```bash
   flutter test
   flutter analyze
   flutter format --set-exit-if-changed .
   ```

7. **Commit your changes** with a clear commit message:
   ```bash
   git commit -m "feat: add new payment method support"
   ```

8. **Push to your fork**:
   ```bash
   git push origin feature/your-feature-name
   ```

9. **Create a Pull Request** with a clear description of your changes

## 📋 Coding Standards

### Dart/Flutter Standards

- Follow the [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use meaningful variable and function names
- Add comments for complex logic
- Keep functions small and focused
- Use proper error handling

### Architecture Guidelines

- Follow Clean Architecture principles
- Use BLoC pattern for state management
- Implement proper separation of concerns
- Add unit tests for business logic
- Use dependency injection with GetIt

### Code Style

```dart
// ✅ Good
class ProductRepository {
  Future<Either<Failure, List<Product>>> getProducts() async {
    // Implementation
  }
}

// ❌ Bad
class ProductRepo {
  Future<List<Product>> getProducts() async {
    // Implementation without error handling
  }
}
```

### File Naming

- Use snake_case for file names: `product_repository.dart`
- Use PascalCase for class names: `ProductRepository`
- Use camelCase for variables and functions: `getProducts`

## 🧪 Testing

### Unit Tests

- Write tests for all business logic
- Test both success and failure scenarios
- Use meaningful test names
- Follow AAA pattern (Arrange, Act, Assert)

```dart
test('should return products when API call is successful', () async {
  // Arrange
  when(mockDataSource.getProducts()).thenAnswer(
    (_) async => Right(mockProducts),
  );

  // Act
  final result = await repository.getProducts();

  // Assert
  expect(result, Right(mockProducts));
});
```

### Widget Tests

- Test UI components in isolation
- Mock dependencies
- Test user interactions
- Verify state changes

### Integration Tests

- Test complete user flows
- Test API integrations
- Test navigation flows

### Manual Testing

Before submitting a pull request, please test:

- [ ] App builds successfully on Android
- [ ] App builds successfully on iOS
- [ ] All existing functionality works as expected
- [ ] New features work correctly
- [ ] UI looks good in both light and dark themes
- [ ] No console errors or warnings
- [ ] Performance is acceptable

## 📝 Documentation

### Code Documentation

- Add documentation comments for public APIs
- Use clear and concise descriptions
- Include examples for complex functions

```dart
/// Retrieves a list of products from the remote data source.
/// 
/// Returns a [Future] that completes with either:
/// - A [List] of [Product] objects on success
/// - A [Failure] object on error
/// 
/// Example:
/// ```dart
/// final products = await repository.getProducts();
/// products.fold(
///   (failure) => print('Error: ${failure.message}'),
///   (products) => print('Found ${products.length} products'),
/// );
/// ```
Future<Either<Failure, List<Product>>> getProducts();
```

### README Updates

- Update README.md when adding new features
- Include setup instructions for new dependencies
- Update screenshots or demos if UI changes

## 🔄 Pull Request Process

### Before Submitting

1. **Ensure all tests pass**:
   ```bash
   flutter test
   flutter analyze
   flutter format --set-exit-if-changed .
   ```

2. **Update documentation** if needed

3. **Add screenshots** for UI changes

4. **Test on multiple devices** if applicable

### Pull Request Template

Use the provided PR template and include:

- **Description**: What changes were made and why
- **Type of change**: Bug fix, feature, documentation, etc.
- **Testing**: How the changes were tested
- **Screenshots**: For UI changes
- **Breaking changes**: If any

### Review Process

1. **Code review** by maintainers
2. **Address feedback** and make requested changes
3. **Maintainer approval** required for merge

## 🏷️ Issue Labels

- `bug`: Something isn't working
- `enhancement`: New feature or request
- `documentation`: Improvements or additions to documentation
- `good first issue`: Good for newcomers
- `help wanted`: Extra attention is needed
- `question`: Further information is requested
- `wontfix`: This will not be worked on

## 🎯 Development Workflow

### Branch Strategy

- `main`: Production-ready code
- `develop`: Integration branch for features
- `feature/*`: New features
- `bugfix/*`: Bug fixes
- `hotfix/*`: Critical production fixes

### Release Process

1. **Create release branch** from main
2. **Update version** in pubspec.yaml
3. **Update CHANGELOG.md**
4. **Create release** on GitHub
5. **Merge to main**

## 📞 Getting Help

- **GitHub Issues**: For bug reports and feature requests
- **Discussions**: For questions and general discussion
- **Documentation**: Check the README and code comments

## 🙏 Recognition

Contributors will be recognized in:
- The project README
- Release notes
- GitHub contributors page

## 📄 License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

Thank you for contributing to the Flutter Ecommerce App! 🚀 