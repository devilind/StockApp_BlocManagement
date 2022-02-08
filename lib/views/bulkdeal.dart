// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:go_india_stocks_assignment/api_manage.dart/api_handling.dart';
import 'package:go_india_stocks_assignment/models/deal_model.dart';

import 'package:intl/intl.dart';

class BulkDealTab extends StatefulWidget {
  const BulkDealTab({Key? key}) : super(key: key);

  @override
  _BulkDealTabState createState() => _BulkDealTabState();
}

class _BulkDealTabState extends State<BulkDealTab> {
  final dataBloc = ApiHandlerBloc();

  @override
  void initState() {
    dataBloc.dealEventSink.add(DealAction.Bulk);
    dataBloc.dealEventSink.add(DealAction.All);
    super.initState();
  }

  @override
  void dispose() {
    dataBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                dataBloc.dealEventSink.add(DealAction.All);
                dataBloc.colorEventSink.add(DealAction.All);
              },
              child: StreamBuilder<List<Color>>(
                  stream: dataBloc.colorStream,
                  builder: (context, snapshot) {
                    return Container(
                      width: size.width * 0.25,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Color(0XFF9aabdd),
                        border: Border.all(
                            color: snapshot.hasData
                                ? snapshot.data![0]
                                : Colors.black,
                            width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          'All',
                          style: TextStyle(
                              color: snapshot.hasData
                                  ? snapshot.data![0]
                                  : Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  }),
            ),
            GestureDetector(
              onTap: () {
                dataBloc.dealEventSink.add(DealAction.Buy);
                dataBloc.colorEventSink.add(DealAction.Buy);
              },
              child: StreamBuilder<List<Color>>(
                  stream: dataBloc.colorStream,
                  builder: (context, snapshot) {
                    return Container(
                      width: size.width * 0.25,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Color(0XFF6aa563),
                        border: Border.all(
                            color: snapshot.hasData
                                ? snapshot.data![1]
                                : Colors.white,
                            width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          'Buy',
                          style: TextStyle(
                              color: snapshot.hasData
                                  ? snapshot.data![1]
                                  : Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  }),
            ),
            GestureDetector(
              onTap: () {
                dataBloc.dealEventSink.add(DealAction.Sell);
                dataBloc.colorEventSink.add(DealAction.Sell);
              },
              child: StreamBuilder<List<Color>>(
                  stream: dataBloc.colorStream,
                  builder: (context, snapshot) {
                    return Container(
                      width: size.width * 0.25,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Color(0XFFcf4448),
                        border: Border.all(
                            color: snapshot.hasData
                                ? snapshot.data![2]
                                : Colors.white,
                            width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          'Sell',
                          style: TextStyle(
                              color: snapshot.hasData
                                  ? snapshot.data![2]
                                  : Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          width: size.width,
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 2),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: TextField(
              enableSuggestions: true,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Search Client Name",
                hintStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
              ),
              onChanged: (value) => dataBloc.searchEventSink.add(value),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Material(
          elevation: 10,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: size.width * 0.95,
            height: size.height * 0.65,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: StreamBuilder<List<Data>>(
              stream: dataBloc.dealStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      snapshot.error.toString(),
                    ),
                  );
                } else if (snapshot.hasData) {
                  return ListView.builder(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: false,
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        var deal = snapshot.data?[index];
                        var formattedTime =
                            DateFormat('dd MMM yyyy').format(deal!.dealDate);
                        String varDealType = 'Bought';
                        Color kcolor = Colors.black;
                        var kvalue = numDifferentiation(deal.value);

                        if (deal.dealType == "BUY") {
                          varDealType = 'Bought';
                          kcolor = Colors.green;
                        } else {
                          varDealType = 'Sold';
                          kcolor = Colors.red;
                        }
                        var kstyle = TextStyle(
                            fontSize: 13,
                            color: kcolor,
                            fontWeight: FontWeight.bold);
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Material(
                            elevation: 3,
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              width: size.width * 0.9,
                              height: 120,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 4, right: 15, top: 4),
                                    child: SizedBox(
                                      height: 110,
                                      width: 5,
                                      child: VerticalDivider(
                                        color: kcolor,
                                        thickness: 5,
                                        width: 5,
                                      ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: SizedBox(
                                              width: size.width * 0.6,
                                              height: 30,
                                              child: Text(
                                                deal.clientName,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                          ),
                                          FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: SizedBox(
                                              width: 80,
                                              height: 30,
                                              child: Text(
                                                formattedTime,
                                                style: TextStyle(
                                                    color: Colors.grey.shade700,
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            '$varDealType ${deal.quantity} shares ',
                                            style: kstyle,
                                          ),
                                          Text(
                                            '@ Rs ${deal.tradePrice}',
                                            style: TextStyle(
                                                color: Colors.grey.shade700,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            'Value RS $kvalue ',
                                            style: TextStyle(
                                                color: Colors.blue.shade900,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        )
      ],
    );
  }

  void searchDeal(String query) {}

  String numDifferentiation(value) {
    var val = double.parse(value);
    String val1 = '';
    if (val >= 10000000) {
      val1 = (val / 10000000).toStringAsFixed(2) + ' Cr';
    } else if (val >= 100000) {
      val1 = (val / 100000).toStringAsFixed(2) + ' Lac';
    }
    return val1;
  }
}
