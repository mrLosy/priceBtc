import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';

enum PriceEvent { priceBtc, priceEth }

class CounterBloc {
  String _price = "Tap to get price";

  final _inputEventController = StreamController<PriceEvent>();
  StreamSink get inputEventSink => _inputEventController.sink;

  final _outputStreamController = StreamController<String>();
  Stream<String> get outputStateStream => _outputStreamController.stream;

  void _mapEventToState(PriceEvent event) async {
    List<BinanceElem> testList = await Binance().fetchJsonBinance();
    for (var element in testList) {
      if (event == PriceEvent.priceBtc) {
        if (element.symbol == "BTCUSDT") {
          _price = 'BTC = ' +
              element.lastPrice.substring(0, element.lastPrice.indexOf('.')) +
              'USDT';
        }
      }
      if (event == PriceEvent.priceEth) {
        if (element.symbol == "ETHUSDT") {
          _price = 'ETH = ' +
              element.lastPrice.substring(0, element.lastPrice.indexOf('.')) +
              'USDT';
        }
      }
    }
    _outputStreamController.sink.add(_price);
  }

  CounterBloc() {
    _inputEventController.stream.listen(_mapEventToState);
  }

  void dispose() {
    _inputEventController.close;
    _outputStreamController.close();
  }
}

class Binance {
  late List<BinanceElem> binanceList;

  Future<List<BinanceElem>> fetchJsonBinance() async {
    final responce =
        await get(Uri.parse('https://api.binance.com/api/v3/ticker/24hr'));
    if (responce.statusCode == 200) {
      List<dynamic> body = jsonDecode(responce.body);

      List<BinanceElem> elements = body
          .map(
            (dynamic item) => BinanceElem.fromJson(item),
          )
          .toList();

      return elements;
    } else {
      throw Exception('Failed to load Binance Element');
    }
  }
}

class BinanceElem {
  late String symbol;
  late String lastPrice;
  late int lastId;

  BinanceElem(
      {required this.symbol, required this.lastPrice, required this.lastId});

  factory BinanceElem.fromJson(Map<String, dynamic> json) {
    return BinanceElem(
      symbol: json['symbol'] as String,
      lastPrice: json['lastPrice'] as String,
      lastId: json['lastId'] as int,
    );
  }
}
