import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tmb_merchant_app/qr/qr.dart';

class QrBloc extends Bloc<QrEvent, QrState> {
  @override
  // TODO: implement initialState
  QrState get initialState => QrState.initial();

  @override
  Stream<QrState> mapEventToState(QrState currentState, QrEvent event) async* {
    if (event is GenerateQr) {
      yield QrState.loading();

      try {
        final response = await _generateQrFromApi(
            ref1: event.request.ref1, ref2: event.request.ref2, price: event.request.price);
        inCurrentRequest(event.request);
        yield QrState.success(response,event.request);
      } catch (error) {
        yield QrState.failure(error.toString());
      }
    }

    if (event is GenerateQrSuccess) {
      yield QrState.initial();
    }

    if (event is EditQr) {
      yield QrState.loading();
      await _editQrCode();
      yield QrState.initial();
    }
  }


  final _currentRequest = BehaviorSubject<QrRequest>();
  // Streams
  Observable<QrRequest> get outCurrentRequest => _currentRequest.stream;
  // Sinks
  Function(QrRequest) get inCurrentRequest => _currentRequest.sink.add;

  Future<String> _generateQrFromApi({
    @required String ref1,
    @required String ref2,
    @required String price,
  }) async {
    
    await Future.delayed(Duration(seconds: 1));
    return 'QR Code';
  }

  Future<void> _editQrCode() async {
    /// read from keystore/keychain
    await Future.delayed(Duration(seconds: 1));
    return;
  }
}
