import 'package:flutter/material.dart';
import 'package:go_india_stocks_assignment/views/blockdeal.dart';
import 'package:go_india_stocks_assignment/views/bulkdeal.dart';

import 'api_manage.dart/api_handling.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final dataBloc = ApiHandlerBloc();

  @override
  Widget build(BuildContext context) {
    print(
        "Myself Atul Rathour, I hope it meets your requirement's. Waiting for your response @atul.eathour.98@gmail.com.");
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: CustomScrollView(
          slivers: [
            const SliverAppBar(
              expandedHeight: 80,
              bottom: TabBar(
                tabs: [
                  Tab(
                    text: "Bulk Deal",
                  ),
                  Tab(
                    text: "Block Deal",
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                width: size.width,
                height: size.height,
                child: const TabBarView(
                  children: [
                    BulkDealTab(),
                    BlockDealTab(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
