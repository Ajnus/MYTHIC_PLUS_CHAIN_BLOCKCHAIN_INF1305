import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'login.dart';
import 'models/appstate.dart';
import 'slider_widget.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:web3dart/web3dart.dart';
import 'package:flutter/services.dart';

class Login1Page extends StatefulWidget {
  Login1Page({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _Login1PageState createState() => _Login1PageState();
}

class _Login1PageState extends State<Login1Page> {
  Client httpClient;
  Web3Client ethClient;
  int myAmount = 0;
  var playerNome;
  var playerServer;
  var playerAddress;
  var playerCusto;
  var playerMasmorra;
  final myAddress = "0x980CBd8423BfcB7503703090e5500edA35C305b1";
  String txHash;
  bool data = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    httpClient = Client();
    ethClient = Web3Client(
        "https://kovan.infura.io/v3/949e7a9ae944419f92c8e9096f1f3454",
        httpClient);
    getPlayer(myAddress, 4);

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

  Future<DeployedContract> loadContract() async {
    String abi = await rootBundle.loadString("assets/abi.json");
    String contractAddress = "0xf94c34fd3C462c342749893203682504b3114cCc";

    final contract = DeployedContract(ContractAbi.fromJson(abi, "Run"),
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

  Future<void> getPlayer(String targetAddress, int id) async {
    //EthereumAddress address = EthereumAddress.fromHex(targetAddress);
    List<dynamic> result = await query("get", [(BigInt.from(id))]);

    playerNome = result[0];
    playerServer = result[1];
    playerAddress = result[2];
    playerCusto = result[3];
    playerMasmorra =result[4];
    //data = true;
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
  }

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
          //.py12()
          ,
          //(context.percentHeight * 1).heightBox,
          "\n A ser contratado: $playerNome".text.fontFamily('Inconsolata').xl.gray400.bold.center.make()
          //.py12()
          ,
          //(context.percentHeight * 1).heightBox,
          "\n Servidor: $playerServer".text.fontFamily('Inconsolata').xl.gray400.bold.center.make()
          //.py1()
          ,
          //(context.percentHeight * 1).heightBox,
          " Seu endereço: \n $playerAddress"
              .text
              .fontFamily('Inconsolata')
              .xl
              .gray400
              .bold
              .make()
              .py12(),
          (context.percentHeight * 3).heightBox,
          "Deseja contratar este player para $playerMasmorra por $playerCusto wei?"
              .text
              .fontFamily('Inconsolata')
              .xl
              .gray400
              .bold
              .center
              .make()
              .py12(),
          Container(
              height: 50,
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Center(
                  child: RaisedButton(
                textColor: Colors.white,
                color: Colors.black,
                child: Text('CONTRATAR'),
                onPressed: () {
                  //getPlayer(myAddress, 4);
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
              ))),
        ])
      ]),
    );
  }
}
