import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:thing/src/login0.dart';
import 'src/models/appstate.dart';
import 'src/slider_widget.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:web3dart/web3dart.dart';
import 'package:flutter/services.dart';
import 'src/login.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Thing',
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
  String txHash;
  bool data = false;

  static AudioCache player2 = new AudioCache();
  static const login = "music/ready_check.mp3";

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    /*httpClient = Client();
    ethClient = Web3Client(
        "https://kovan.infura.io/v3/949e7a9ae944419f92c8e9096f1f3454",
        httpClient);
    getBalance(myAddress);*/

    showOverlay2(context);
    showOverlay2(context);
    showOverlay3(context);
    showOverlay3(context);
  }

  showOverlay2(BuildContext context) async {
    OverlayState overlayState = Overlay.of(context);
    OverlayEntry overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
            top: MediaQuery.of(context).size.height / 2.0 - 85.0,
            right: 0.0,
            child: Image.asset('assets/images/mythicStone4.png')));

    overlayState.insert(overlayEntry);
  }

  showOverlay3(BuildContext context) async {
    OverlayState overlayState = Overlay.of(context);

    OverlayEntry overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
            top: MediaQuery.of(context).size.height / 2.0 - 85.0,
            left: 0.0,
            child: Image.asset('assets/images/mythicStone4.png')));

    overlayState.insert(overlayEntry);
  }

  /*Future<DeployedContract> loadContract() async {
    String abi = await rootBundle.loadString("assets/abi.json");
    String contractAddress = "0x99CF4c4CAE3bA61754Abd22A8de7e8c7ba3C196d";

    final contract = DeployedContract(ContractAbi.fromJson(abi, "Mitica+Chain"),
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
    txHash = response;
    setState(() {});
    return response;
  }

  Future<String> withDrawCoin() async {
    var bigAmount = BigInt.from(myAmount);
    var response = await submit("withdrawBalance", [bigAmount]);

    print("Withdraw");
    txHash = response;
    setState(() {});
    return response;
  }

  Future<String> submit(String functionName, List<dynamic> args) async {
    EthPrivateKey credentials = EthPrivateKey.fromHex(
        "875adca609077681a6ec760ee789fdba7b92eeb73c6da0fa46e1806aaf717367");

    DeployedContract contract = await loadContract();
    final ethFunction = contract.function(functionName);
    final result = await ethClient.sendTransaction(
        credentials,
        Transaction.callContract(
            contract: contract, function: ethFunction, parameters: args),
        fetchChainIdFromNetworkId: true);
    return result;
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Vx.red900,
      body: ZStack([
        VxBox()
            .black
            .size(context.screenWidth, context.percentHeight * 45)
            .make(),
        VStack([
          (context.percentHeight * 10).heightBox,
          Center(child: Image.asset('assets/images/Webp.net-resizeimage2.png')),
          "MYTHIC+ CHAIN"
              .text
              .fontFamily('LifeCraft')
              .xl5
              .yellow400
              .center
              .makeCentered()
              .py12(),
          Center(
              child: Image.asset(
                  'assets/images/Webp.net-resizeimage2_-_Copia-removebg-preview.png')),
          "\nWorld of Warcraft blockchain WTS\n"
              .text
              .xl2
              .gray400
              .bold
              .center
              .makeCentered()
              .py12(),
          (context.percentHeight * 1).heightBox,
        ]),
        Padding(
          padding: EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(200),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  controller: nameController,
                  decoration: InputDecoration(
                    disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    labelText: 'Mythic ID',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextField(
                  obscureText: true,
                  style: TextStyle(color: Colors.white),
                  controller: passwordController,
                  decoration: InputDecoration(
                    //border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                    disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              FlatButton(
                onPressed: () {
                  //forgot password screen
                },
                textColor: Colors.white,
                child: Text('Forgot Password'),
              ),
              Container(
                  height: 50,
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: RaisedButton(
                    textColor: Colors.white,
                    color: Colors.blue,
                    child: Text('LOGIN'),
                    onPressed: () {
                      print(nameController.text);
                      print(passwordController.text);
                      //AppState.login;
                      player2.play(login);
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Login0Page()));
                    },
                  )),
              Container(
                  child: Row(
                children: <Widget>[
                  Text('Does not have account?',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  FlatButton(
                    textColor: Colors.white,
                    child: Text(
                      'Sign in',
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      //signup screen
                    },
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ))
            ],
          ),
        ),
      ]),
    );
  }
}

/*VxBox(
                  child: VStack([
            "(Not Republic Credits) Balance"
                .text
                .gray700
                .xl2
                .semiBold
                .makeCentered(),
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
              max: 100,
              finalVal: (value) {
                myAmount = (value * 100).round();
                print(myAmount);
              }).centered(),
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
          ).p16(),
          if (txHash != null) txHash.text.black.makeCentered().p16() */
