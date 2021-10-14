import 'dart:convert';
import 'package:http/http.dart';

class Binance
{
  late List<BinanceElem> binanceList;

 Future<List<BinanceElem>> fetchJsonBinance() async {
  final responce = await get(Uri.parse('https://api.binance.com/api/v3/ticker/24hr'));
  if (responce.statusCode == 200) {
  List<dynamic> body = jsonDecode(responce.body);

      List<BinanceElem> elements = body
          .map(
            (dynamic item) => BinanceElem.fromJson(item),
          )
          .toList();

      return elements;
  } 
  else {
  throw Exception('Failed to load Binance Element');
  }
}


}


class BinanceElem
{
    late String symbol;
    late String lastPrice;
    late int lastId;

  BinanceElem({
    required this.symbol,
    required this.lastPrice,
    required this.lastId
  });

  factory BinanceElem.fromJson(Map<String, dynamic> json) {
    return BinanceElem(
     symbol: json['symbol'] as String,
     lastPrice: json['lastPrice'] as String,
     lastId: json['lastId'] as int,
    );
  }
}