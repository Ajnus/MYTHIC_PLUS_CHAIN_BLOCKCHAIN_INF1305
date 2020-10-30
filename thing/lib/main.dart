import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:thing/slider_widget.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:web3dart/web3dart.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Thing'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Client httpClient;
  Web3Client ethClient;
  int myAmount = 0;
  var myData;
  final myAddress = "0x980CBd8423BfcB7503703090e5500edA35C305b1";
  bool data = false;

  @override
  void initState() {
    super.initState();
    httpClient = Client();
    ethClient = Web3Client(
        "https://kovan.infura.io/v3/949e7a9ae944419f92c8e9096f1f3454",
        httpClient);
    getBalance(myAddress);
  }

  Future<DeployedContract> loadContract() async {
    String abi = await rootBundle.loadString("assets/abi.json");
    String contractAddress = "0xd0a919CB1e50c2d4512f797499bc6291dcC4582c";

    final contract = DeployedContract(ContractAbi.fromJson(abi, "Thing"),
        EthereumAddress.fromHex(contractAddress));

    return contract;
  }

  Future<List<dynamic>> query(String functionName, List<dynamic> args) async {
    final contract = await loadContract();
    final ethFunction = contract.function(functionName);
    final result = await ethClient.call(
        contract: contract, function: ethFunction, params: args);

    return result;
  }

  Future<void> getBalance(String targetAddress) async {
    //EthereumAddress address = EthereumAddress.fromHex(targetAddress);
    List<dynamic> result = await query("getBalance", []);

    myData = result[0];
    data = true;
    setState(() {});
  }

  Future<String> sendCoin() async {
    var bigAmount = BigInt.from(myAmount);
    var response = await submit("depositBalance", [bigAmount]);

    print("Deposited");
    return response;
  }

  Future<String> withDrawCoin() async {
    var bigAmount = BigInt.from(myAmount);
    var response = await submit("withdrawBalance", [bigAmount]);

    print("Withdraw");
    return response;
  }

  Future<String> submit(String functionName, List<dynamic> args) async{
    EthPrivateKey credentials = EthPrivateKey.fromHex("0x875adca609077681a6ec760ee789fdba7b92eeb73c6da0fa46e1806aaf717367");

    DeployedContract contract = await loadContract();
    final ethFunction = contract.function(functionName);
    final result = await ethClient.sendTransaction(credentials, Transaction.callContract(contract: contract, function: ethFunction, parameters: args), fetchChainIdFromNetworkId: true);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Vx.gray300,
      body: ZStack([
        VxBox()
            .blue600
            .size(context.screenWidth, context.percentHeight * 30)
            .make(),
        VStack([
          (context.percentHeight * 10).heightBox,
          "\$THING".text.xl4.white.bold.center.makeCentered().py16(),
          (context.percentHeight * 5).heightBox,
          VxBox(
                  child: VStack([
            "Balance".text.gray700.xl2.semiBold.makeCentered(),
            10.heightBox,
            data
                ? "\$$myData".text.bold.xl6.makeCentered().shimmer()
                : CircularProgressIndicator().centered()
          ]))
              .p16
              .white
              .size(context.screenWidth, context.percentHeight * 18)
              .rounded
              .shadowXl
              .make()
              .p16(),
          30.heightBox,
          SliderWidget(
            min: 0,
            max: 100, /*finalVal: (value){myAMount = (value*100).round}
          ).centered(),
          HStack(
            [
              FlatButton.icon(
                      onPressed: () => getBalance(myAddress),
                      color: Colors.black,
                      shape: Vx.roundedSm,
                      icon: Icon(Icons.refresh, color: Colors.white),
                      label: "Refresh".text.white.make())
                  .h(50),
              FlatButton.icon(
                      onPressed: () => sendCoin(),
                      color: Colors.lightGreen,
                      shape: Vx.roundedSm,
                      icon: Icon(Icons.call_made, color: Colors.white),
                      label: "Deposit".text.white.make())
                  .h(50),
              FlatButton.icon(
                      onPressed: () => withDrawCoin(),
                      color: Colors.red,
                      shape: Vx.roundedSm,
                      icon: Icon(Icons.call_received, color: Colors.white),
                      label: "Withdraw".text.white.make())
                  .h(50)
            ],
            alignment: MainAxisAlignment.spaceAround,
            axisSize: MainAxisSize.max,
          ).p16()
        ])
      ]),
    );
  }
}
