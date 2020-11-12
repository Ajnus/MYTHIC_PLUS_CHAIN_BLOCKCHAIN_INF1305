import 'dart:async';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:frideos_core/frideos_core.dart';
import 'package:frideos/frideos.dart';
//import '../models/category.dart';
import '../models/models.dart';
//import '../models/question.dart';
import '../models/theme.dart';

/*class AppState extends AppStateModel {
  factory AppState() => _singletonAppState;
  static AudioCache player2 = new AudioCache();
  static AudioCache player3 = new AudioCache();
  static AudioCache player4 = new AudioCache();

  //AudioPlayer stateAudioPlayer = AudioPlayer();

  static const login0 = "ready_check.mp3";

  

  AppState._internal() {
    /*print('-------APP STATE INIT--------');
    _createThemes(themes);
    _loadCategories();

    countdown.value = 10.toString();
    countdown.setTransformer(validateCountdown);

    questionsAmount.value = 5.toString();
    questionsAmount.setTransformer(validateAmount);

    swBloc = SWBloc(
        countdownStream: countdown,
        questions: questions,
        tabController: tabController);*/
  }

  static final AppState _singletonAppState = AppState._internal();

   // TABS
  var tabController = StreamedValue<AppTab>(initialData: AppTab.main);

  set _changeTab(AppTab appTab) => tabController.value = appTab;

  void login() {
    player2.play(login0);
    _changeTab = AppTab.login;
  }

  @override
  void dispose() {
    print('---------APP STATE DISPOSE-----------');
    tabController.dispose();
  }
}*/
