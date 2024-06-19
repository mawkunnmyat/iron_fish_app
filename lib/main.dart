import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(IronFishDataApp());
}

class IronFishDataApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IronFish Data',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: IronFishDataPage(),
    );
  }
}

class IronFishDataPage extends StatefulWidget {
  @override
  _IronFishDataPageState createState() => _IronFishDataPageState();
}

class _IronFishDataPageState extends State<IronFishDataPage> {
  late Future<Map<String, dynamic>> _dataFuture;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // Fetch data immediately when the widget initializes
    _dataFuture = fetchData();

    // Setup a Timer to fetch data every 10 seconds
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      setState(() {
        _dataFuture = fetchData();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<Map<String, dynamic>> fetchData() async {
    final url =
        'https://api.allorigins.win/get?url=${Uri.encodeComponent('https://whattomine.com/coins/411.json?hr=1000.0&p=0.0&fee=5.0&cost=0.0&cost_currency=USD&hcost=0.0&span_br=&span_d=')}';
    
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);
      final responseData = json.decode(decodedResponse['contents']);
      return responseData;
    } else {
      throw Exception('Failed to fetch data. Status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('IronFish Data'),
      ),
      body: FutureBuilder(
        future: _dataFuture,
        builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final data = snapshot.data!;
            return RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  _dataFuture = fetchData();
                });
              },
              child: ListView(
                padding: EdgeInsets.all(16.0),
                children: [
                  buildInfoCard('ID', data['id'], Icons.info),
                  buildInfoCard('Name', data['name'], Icons.label),
                  buildInfoCard('Tag', data['tag'], Icons.tag),
                  buildInfoCard('Algorithm', data['algorithm'], Icons.memory),
                  buildInfoCard('Block Time', data['block_time'], Icons.timer),
                  buildInfoCard('Block Reward', data['block_reward'], Icons.attach_money),
                  buildInfoCard('Block Reward (24h)', data['block_reward24'], Icons.calendar_today),
                  buildInfoCard('Block Reward (3d)', data['block_reward3'], Icons.calendar_today),
                  buildInfoCard('Block Reward (7d)', data['block_reward7'], Icons.calendar_today),
                  buildInfoCard('Last Block', data['last_block'], Icons.block),
                  buildInfoCard('Difficulty', data['difficulty'], Icons.trending_up),
                  buildInfoCard('Difficulty (24h)', data['difficulty24'], Icons.trending_up),
                  buildInfoCard('Difficulty (3d)', data['difficulty3'], Icons.trending_up),
                  buildInfoCard('Difficulty (7d)', data['difficulty7'], Icons.trending_up),
                  buildInfoCard('Nethash', data['nethash'], Icons.network_check),
                  buildInfoCard('Exchange Rate', data['exchange_rate'], Icons.swap_vert),
                  buildInfoCard('Exchange Rate (24h)', data['exchange_rate24'], Icons.swap_vert),
                  buildInfoCard('Exchange Rate (3d)', data['exchange_rate3'], Icons.swap_vert),
                  buildInfoCard('Exchange Rate (7d)', data['exchange_rate7'], Icons.swap_vert),
                  buildInfoCard('Exchange Rate Volume', data['exchange_rate_vol'], Icons.volume_up),
                  buildInfoCard('Exchange Rate Currency', data['exchange_rate_curr'], Icons.attach_money),
                  buildInfoCard('Market Cap', data['market_cap'], Icons.pie_chart),
                  buildInfoCard('Pool Fee', data['pool_fee'], Icons.pool),
                  buildInfoCard('Estimated Rewards', data['estimated_rewards'], Icons.card_giftcard),
                  buildInfoCard('BTC Revenue', data['btc_revenue'], Icons.monetization_on),
                  buildInfoCard('Revenue', data['revenue'], Icons.monetization_on),
                  buildInfoCard('Cost', data['cost'], Icons.money_off),
                  buildInfoCard('Profit', data['profit'], Icons.monetization_on),
                  buildInfoCard('Status', data['status'], Icons.check_circle),
                  buildInfoCard('Lagging', data['lagging'], Icons.sync_problem),
                  buildInfoCard('Testing', data['testing'], Icons.bug_report),
                  buildInfoCard('Listed', data['listed'], Icons.list),
                  buildInfoCard('Timestamp', data['timestamp'], Icons.access_time),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget buildInfoCard(String title, dynamic value, IconData icon) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(value.toString()),
      ),
    );
  }
}
