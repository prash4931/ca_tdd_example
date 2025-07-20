import 'package:data_connection_checker_tv/data_connection_checker.dart';

/// A Generic Abstract Class for Checking Network Connectivity
abstract class NetworkInfo {
  // Checks if the device is connected to the Internet
  Future<bool> get isConnected;
}

/// Concrete Class that implements [NetworkInfo] abstract class.
/// This class uses [DataConnectionChecker] to check the device's networl
/// connectivity
class NetworkInfoImpl implements NetworkInfo {
  final DataConnectionChecker dataConnectionChecker;

  /// Constructor that accepts an instance of [DataConnectionChecker]
  NetworkInfoImpl(this.dataConnectionChecker);

  /// Method to check whether the device is connected to the network or not.
  @override
  Future<bool> get isConnected => dataConnectionChecker.hasConnection;
}
