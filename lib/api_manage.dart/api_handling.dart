// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:go_india_stocks_assignment/models/deal_model.dart';
import 'package:http/http.dart' as http;

enum DealAction { All, Buy, Sell, Block, Bulk }

// Stream Controller of filtering buttons.

class ApiHandlerBloc {
  final _dealStreamController = StreamController<List<Data>>();
  StreamSink<List<Data>> get _dealSink => _dealStreamController.sink;
  Stream<List<Data>> get dealStream => _dealStreamController.stream;

  final _dealEventStreamController = StreamController<DealAction>.broadcast();
  StreamSink<DealAction> get dealEventSink => _dealEventStreamController.sink;
  Stream<DealAction> get _dealEventStream => _dealEventStreamController.stream;

// Border Color Of All, Buy, Sell button.

  final _activeColorController = StreamController<List<Color>>.broadcast();
  StreamSink<List<Color>> get _colorSink => _activeColorController.sink;
  Stream<List<Color>> get colorStream => _activeColorController.stream;

  final _activeColorEventController = StreamController<DealAction>.broadcast();
  StreamSink<DealAction> get colorEventSink => _activeColorEventController.sink;
  Stream<DealAction> get _colorEventStream =>
      _activeColorEventController.stream;

// Client Search Controller

  final _searchStreamController = StreamController<List<Data>>();
  StreamSink<List<Data>> get _searchResultSink => _searchStreamController.sink;
  Stream<List<Data>> get searchResultStream => _searchStreamController.stream;

  final _searchEventStreamController = StreamController<String>();
  StreamSink<String> get searchEventSink => _searchEventStreamController.sink;
  Stream<String> get _searchEventStream => _searchEventStreamController.stream;
// Variables for Deals.

  late DealModel allDeals;
  DealModel buyDeals = DealModel(data: []);
  late DealModel sellDeals = DealModel(data: []);
  String section = 'all';

  ApiHandlerBloc() {
    _dealEventStream.listen((action) async {
      String url =
          'https://www.goindiastocks.com/api/service/GetBulkBlockDeal?fincode=100114&DealType=Bulk_Deal';
      if (action == DealAction.Bulk) {
        url =
            'https://www.goindiastocks.com/api/service/GetBulkBlockDeal?fincode=100114&DealType=Bulk_Deal';
      } else if (action == DealAction.Block) {
        url =
            'https://www.goindiastocks.com/api/service/GetBulkBlockDeal?fincode=100114&DealType=Block_Deal';
      }
      allDeals = await getDeals(url);
      if (action == DealAction.All) {
        try {
          if (allDeals != null) {
            _dealSink.add(allDeals.data);
          } else {
            _dealSink.addError("Something went Wrong");
          }
        } on Exception catch (e) {
          _dealSink.addError(" $e");
        }
      } else if (action == DealAction.Sell) {
        section = 'sell';
        try {
          for (int i = 0; i < allDeals.data.length; i++) {
            if (allDeals.data[i].dealType == 'SELL') {
              sellDeals.data.add(allDeals.data[i]);
            }
            _dealSink.add(sellDeals.data);
          }
        } on Exception catch (e) {
          _dealSink.addError(" $e");
        }
      } else if (action == DealAction.Buy) {
        section = 'buy';
        try {
          for (int i = 0; i < allDeals.data.length; i++) {
            if (allDeals.data[i].dealType == 'BUY') {
              buyDeals.data.add(allDeals.data[i]);
            }
            _dealSink.add(buyDeals.data);
          }
        } on Exception catch (e) {
          _dealSink.addError(" $e");
        }
      }
    });

    _colorEventStream.listen(
      (event) {
        if (event == DealAction.All) {
          List<Color> kcolor = [Colors.black, Colors.white, Colors.white];
          _colorSink.add(kcolor);
        } else if (event == DealAction.Buy) {
          List<Color> kcolor = [Colors.white, Colors.black, Colors.white];
          _colorSink.add(kcolor);
        } else {
          List<Color> kcolor = [
            Colors.white,
            Colors.white,
            Colors.black,
          ];
          _colorSink.add(kcolor);
        }
      },
    );

    _searchEventStream.listen((event) {
      var suggestions;
      if (section == 'all') {
        suggestions = allDeals.data.where((DealModel) {
          final ClientName = DealModel.clientName.toLowerCase();
          final input = event.toLowerCase();
          return ClientName.contains(input);
        }).toList();
      } else if (section == 'buy') {
        suggestions = buyDeals.data.where((DealModel) {
          final ClientName = DealModel.clientName.toLowerCase();
          final input = event.toLowerCase();
          return ClientName.contains(input);
        }).toList();
      } else {
        suggestions = sellDeals.data.where((DealModel) {
          final ClientName = DealModel.clientName.toLowerCase();
          final input = event.toLowerCase();
          return ClientName.contains(input);
        }).toList();
      }
      _dealSink.add(suggestions);
    });
  }

  Future<DealModel> getDeals(String URL) async {
    var client = http.Client();
    Uri url = Uri.parse(URL);
    ;
    var dealModel;

    try {
      var response = await client.get(url);
      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = json.decode(jsonString);

        dealModel = DealModel.fromJson(jsonMap);
      }
    } catch (Exception) {
      return dealModel;
    }

    return dealModel;
  }

  void dispose() {
    _dealStreamController.close();
    _dealEventStreamController.close();
  }
}
