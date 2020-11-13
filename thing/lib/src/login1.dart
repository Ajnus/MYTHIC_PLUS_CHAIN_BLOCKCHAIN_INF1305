import 'dart:io';

import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'login.dart';
import 'models/appstate.dart';
import 'slider_widget.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:web3dart/web3dart.dart';
import 'package:flutter/services.dart';
import 'package:tuple/tuple.dart';

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
  String playerNome;
  String playerGuild;
  String playerServer;
  var playerAddress;
  int playerCusto;
  String playerMasmorra;
  final myAddress = "0x980CBd8423BfcB7503703090e5500edA35C305b1";
  String txHash;
  //bool data = false;
  String valorCasa;
  String valorPlayer;
  String troco;
  int contratado;

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  static AudioCache player2 = new AudioCache();
  static const chaChing = "music/Cash Register Cha-Ching _ Sound Effect.mp3";

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
    String contractAddress = "0x3f46e85df9A0DcB396f0f3437Ef092dC18232964";

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
    playerGuild = result[1];
    playerServer = result[2];
    playerAddress = result[3];
    playerCusto = int.parse(result[4].toString());
    playerMasmorra = result[5];
    //data = true;
    setState(() {});
  }

  Future<void> sendMoney(String targetAddress, int id) async {
    EthereumAddress address = EthereumAddress.fromHex(targetAddress);
    //var contratadoID = BigInt.from(id);
    //dynamic idd = id;
    //idd = BigInt.from(id);
    final result = await submit("sendMoney", [(BigInt.from(id))]);
    List<dynamic> resultQ = await query("postSendMoney", []);

    print("Deposited");
    valorCasa = resultQ[0].toString();
    valorPlayer = resultQ[1].toString();
    troco = resultQ[2].toString();
    txHash = result;
    contratado = 1;
    //data = true;
    //return response;

    setState(() {});
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
            value: EtherAmount.inWei(BigInt.from(playerCusto)),
            contract: contract,
            function: ethFunction,
            parameters: args),
        fetchChainIdFromNetworkId: true);
    return result;
  }

  Future<Tuple2<List<dynamic>, String>> submitQuery(
      EthereumAddress address, String functionName, List<dynamic> args) async {
    EthPrivateKey credentials = EthPrivateKey.fromHex(
        "875adca609077681a6ec760ee789fdba7b92eeb73c6da0fa46e1806aaf717367");

    DeployedContract contract = await loadContract();
    final ethFunction = contract.function(functionName);
    final result = await ethClient.sendTransaction(
        credentials,
        Transaction.callContract(
            from: address,
            value: EtherAmount.inWei(BigInt.from(playerCusto)),
            contract: contract,
            function: ethFunction,
            parameters: args),
        fetchChainIdFromNetworkId: true);

    final resultQ = await ethClient.call(
        sender: address,
        contract: contract,
        function: ethFunction,
        params: args);

    final resultF = Tuple2<List<dynamic>, String>(resultQ, result);

    return resultF;
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
              .py12(),
          //(context.percentHeight * 1).heightBox,
          "\n A ser contratado: $playerNome"
              .text
              .fontFamily('Inconsolata')
              .xl
              .white
              .bold
              .center
              .make()
          //.py12()
          ,
          //(context.percentHeight * 1).heightBox,
          "\n Guilda: $playerGuild"
              .text
              .fontFamily('Inconsolata')
              .xl
              .white
              .bold
              .center
              .make()
          //.py12()
          ,
          //(context.percentHeight * 1).heightBox,
          "\n Servidor: $playerServer"
              .text
              .fontFamily('Inconsolata')
              .xl
              .white
              .bold
              .center
              .make()
          //.py1()
          ,
          //(context.percentHeight * 1).heightBox,
          " Endereço da carteira: \n $playerAddress"
              .text
              .fontFamily('Inconsolata')
              .xl
              .white
              .bold
              .make()
              .py12(),
          (context.percentHeight * 3).heightBox,
          "Deseja contratar este player para $playerMasmorra por $playerCusto wei?"
              .text
              .fontFamily('Inconsolata')
              .xl
              .white
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
                  player2.play(chaChing);

                  sendMoney(myAddress, 4);
                  print('passou');

                  /*Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));*/
                },
              ))),
          if (txHash != null)
            "Taxa de transação: $valorCasa wei, valor transferido: $valorPlayer wei, troco: $troco wei. transação:"
                .text
                .fontFamily('Inconsolata')
                .xl
                .white
                .bold
                .center
                .make()
                .py12(),
          if (txHash != null)
            SelectableText("$txHash",
                showCursor: true,
                autofocus: true,
                dragStartBehavior: DragStartBehavior.start,
                textScaleFactor: 1.25,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Inconsolata',
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
        ])
      ]),
    );
  }
}
