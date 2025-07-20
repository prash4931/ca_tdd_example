import 'package:ca_tdd_example/core/network/network_info.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDataConnectionChecker extends Mock implements DataConnectionChecker {}

void main() {
  late NetworkInfoImpl networkInfo;
  late MockDataConnectionChecker mockDataConnectionChecker;

  setUp(() {
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkInfo = NetworkInfoImpl(mockDataConnectionChecker);
  });

  group('isConnected', () {
    test(
      'should forward the call to the DataConnectionChecker.hasConnection',
      () {
        // arrange
        final tHasConnectionFuture = Future.value(true);
        when(
          () => mockDataConnectionChecker.hasConnection,
        ).thenAnswer((_) => tHasConnectionFuture);

        // act
        final result = networkInfo.isConnected;

        // assert
        expect(result, tHasConnectionFuture);
      },
    );
  });
}
