// import 'package:dio/dio.dart';
// import 'package:equatable/equatable.dart';
//
// class Failure extends Equatable {
//   final String message;
//   const Failure(this.message);
//
//   @override
//   List<Object> get props => [message];
// }
//
// class RemoteFailure extends Failure {
//   final DioExceptionType errorType;
//
//   final int? errorCode;
//
//   const RemoteFailure(
//       {this.errorCode, required message, required this.errorType})
//       : super(message);
//
//   @override
//   List<Object> get props => [errorType];
// }
//
// class LocalFailure extends Failure {
//   final int error;
//   final String? extraInfo;
//
//   const LocalFailure({
//     required message,
//     required this.error,
//     this.extraInfo,
//   }) : super(message);
//
//   @override
//   List<Object> get props => [error];
// }
