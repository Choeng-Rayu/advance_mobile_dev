/// A class to handle async states: loading, error, and success
sealed class AsyncValue<T> {
  const AsyncValue();

  /// Creates a loading state
  const factory AsyncValue.loading() = _Loading;

  /// Creates an error state with an exception
  const factory AsyncValue.error(Object exception) = _Error;

  /// Creates a success state with data
  const factory AsyncValue.data(T value) = _Data;

  /// Check if the state is loading
  bool get isLoading => this is _Loading;

  /// Check if the state is error
  bool get hasError => this is _Error;

  /// Check if the state has data
  bool get hasData => this is _Data;

  /// Get the data if available, otherwise return null
  T? get dataOrNull => this is _Data ? (this as _Data<T>).value : null;

  /// Get the error if available, otherwise return null
  Object? get errorOrNull =>
      this is _Error ? (this as _Error<T>).exception : null;

  /// Pattern matching for AsyncValue
  R when<R>({
    required R Function() loading,
    required R Function(Object exception) error,
    required R Function(T value) data,
  }) {
    if (this is _Loading) {
      return loading();
    } else if (this is _Error) {
      return error((this as _Error<T>).exception);
    } else {
      return data((this as _Data<T>).value);
    }
  }
}

class _Loading<T> extends AsyncValue<T> {
  const _Loading();
}

class _Error<T> extends AsyncValue<T> {
  final Object exception;

  const _Error(this.exception);
}

class _Data<T> extends AsyncValue<T> {
  final T value;

  const _Data(this.value);
}
