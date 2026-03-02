# Riverpod State Management in Flutter Template

## Overview

This document explains how Riverpod is used for state management in the `flutter_template_riverpod` project. The project follows a clean architecture pattern with feature-based organization and uses modern Riverpod practices.

## Core Concepts

### 1. State Definition (`home_state.dart`)

The state is defined using Freezed for immutable data classes:

```dart
@freezed
class HomeState with _$HomeState {
  factory HomeState({
    @Default([]) List<Movie> movies,
    @Default(1) int page,
    @Default(1) int totalPages,
    @Default(false) bool isLoadingMore,
  }) = _HomeState;
}
```

### 2. State Notifier (`home_notifier.dart`)

The notifier handles business logic and state updates:

```dart
@riverpod
class HomeNotifier extends _$HomeNotifier {
  @override
  FutureOr<HomeState> build() {
    return _fetchMovies(page: 1);
  }

  Future<HomeState> _fetchMovies({required int page}) async {
    final repository = ref.read(movieRepositoryProvider);
    final response = await repository.getMovies(page: page);
    return HomeState(
      movies: response.movies,
      page: page,
      totalPages: response.totalPages,
    );
  }

  Future<void> setPage(int page) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchMovies(page: page));
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchMovies(page: 1));
  }
}
```

### 3. UI Integration (`home_page.dart`)

The UI consumes and interacts with the state:

```dart
// Watching the state
final homeState = ref.watch(homeNotifierProvider);

// Handling different states
homeState.when(
  data: (data) => HomePageContents(state: data),
  loading: () => const CircularProgressIndicator(),
  error: (e, __) => Text(e.toString()),
);

// Updating state
onRefresh: () => ref.read(homeNotifierProvider.notifier).refresh(),
```

## Architecture Flow

1. **State Definition**: Define immutable state using Freezed
2. **Notifier Implementation**: Handle business logic in AsyncNotifier
3. **UI Consumption**: Watch state changes and rebuild UI accordingly
4. **State Updates**: Use notifier methods to trigger state changes

## Key Riverpod Features Used

### AsyncValue
- Handles loading states automatically
- Provides error handling out of the box
- Makes UI resilient to async operations

### Providers Hierarchy
- `Provider`: For services and dependencies
- `AsyncNotifier`: For complex state management
- `FutureProvider`: For simple async data

## Best Practices Demonstrated

1. **Separation of Concerns**: State logic is separated from UI
2. **Immutability**: All state changes create new instances
3. **Error Handling**: Proper error states are managed
4. **Loading States**: Automatic loading indicators
5. **Testability**: Business logic is easily testable

## Usage Patterns

### Reading State
```dart
final state = ref.watch(provider);
```

### Updating State
```dart
ref.read(provider.notifier).methodName();
```

### Auto-Dispose
Providers automatically dispose when no longer needed

## Benefits of This Approach

1. **Predictable State Changes**: All mutations go through notifiers
2. **Performance**: Selective rebuilding with provider filtering
3. **Debugging**: Clear state transitions and debugging tools
4. **Scalability**: Can handle complex state interactions
5. **Type Safety**: Compile-time safety with Freezed and Riverpod

This pattern can be reused across different features in the application for consistent state management.