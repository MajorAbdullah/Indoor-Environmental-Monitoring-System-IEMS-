import 'dart:async';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:rive/rive.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}

class CurrentAnalysis extends StatefulWidget {
  const CurrentAnalysis({super.key});

  @override
  _CurrentAnalysisState createState() => _CurrentAnalysisState();
}

class _CurrentAnalysisState extends State<CurrentAnalysis> {
  final databaseReference = FirebaseDatabase.instance.ref('data');

  Map<String, dynamic> lastData = {};
  var showMoreElements = false;

  late AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _fetchLastData();
    player = AudioPlayer();

    player.setReleaseMode(ReleaseMode.stop);
    databaseReference.onChildAdded.listen((event) async {
      debugPrint('Updating Values$lastData');

      await _fetchLastData();
      await checkAqi();
    });
  }

  checkAqi() {
    if (int.parse(lastData.values.elementAt(14)) >= 200) {
      debugPrint('Playing');
      playSound();
    } else {
      debugPrint('Stopping');
      player.stop();
    }
  }

  Future<void> _fetchLastData() async {
    DatabaseEvent event = await databaseReference.once();
    DataSnapshot snapshot = event.snapshot;
    Map<String, dynamic> data = {};
    if (snapshot.value != null) {
      print(snapshot.children.last.value
          .toString()
          .split(",")
          .toList()[1]
          .split(":"));
      int len = 18;
      var dic = snapshot.children.last.value
          .toString()
          .replaceAll("'", '')
          .replaceAll('"', '')
          .replaceAll("{", '')
          .replaceAll("}", '')
          .split(",");
      data[dic[0].split(":")[0]] = dic[0].split(":")[1];
      data[dic[1].split(":")[0]] =
          "${dic[1].split(":")[1]}:${dic[1].split(":")[1]}";
      for (int i = 2; i < len; i++) {
        data[dic[i].split(":")[0]] = dic[i].split(":")[1];
      }
      if (mounted) {
        // Check if the widget is still mounted
        setState(() {
          lastData = Map<String, dynamic>.from(data);
        });
      }
    }
  }

  Future<void> playSound() async {
    try {
      debugPrint('Audio Playing');
      await player.setSource(AssetSource('intruder_alarm.mp3'));
      await player.resume();
    } catch (e) {
      debugPrint('Error playing audio: $e');
    }
  }

  late List<_ChartData> data;
  late TooltipBehavior _tooltip;

  @override
  Widget build(BuildContext context) {
    data = [
      _ChartData('PM 2.5', double.parse(lastData.values.elementAt(2))),
      _ChartData('PM 10', double.parse(lastData.values.elementAt(3))),
      _ChartData('NO', double.parse(lastData.values.elementAt(4))),
      _ChartData('NO2', double.parse(lastData.values.elementAt(5))),
      _ChartData('NOx', double.parse(lastData.values.elementAt(6))),
      _ChartData('NH3', double.parse(lastData.values.elementAt(7))),
      _ChartData('CO', double.parse(lastData.values.elementAt(8))),
      _ChartData('SO2', double.parse(lastData.values.elementAt(9))),
      _ChartData('O3', double.parse(lastData.values.elementAt(10))),
      _ChartData('Benzene', double.parse(lastData.values.elementAt(11))),
      _ChartData('Toulene', double.parse(lastData.values.elementAt(12))),
      _ChartData('Xylene', double.parse(lastData.values.elementAt(13))),
      _ChartData('AQI', double.parse(lastData.values.elementAt(14))),
    ];
    _tooltip = TooltipBehavior(
        borderColor: Colors.white, enable: true, color: Colors.black);
    return Stack(
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 10),
        ),
        const RiveAnimation.asset('assets/RiveAssets/shapes.riv',
            fit: BoxFit.fitHeight),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 10),
          child: const SizedBox(),
        ),
        Center(
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('Current Analysis'.toUpperCase(),
                        style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            letterSpacing: 5,
                            fontSize: 25.0,
                            color: Colors.white)),
                  ),
                  if (lastData != null ||
                      lastData.isNotEmpty ||
                      lastData.values.elementAt(1) != null)
                    Column(
                      children: [
                        BlurryContainer(
                          child: SfCartesianChart(
                              backgroundColor: Colors.white70,
                              primaryXAxis: const CategoryAxis(),
                              primaryYAxis: const NumericAxis(
                                minimum: 0,
                                maximum: 300,
                                interval: 10,
                              ),
                              tooltipBehavior: _tooltip,
                              series: <BarSeries<_ChartData, String>>[
                                BarSeries<_ChartData, String>(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  dataSource: data,
                                  xValueMapper: (_ChartData data, _) => data.x,
                                  yValueMapper: (_ChartData data, _) => data.y,
                                  name: 'AQI',
                                  color: Colors.blue,
                                  borderColor: Colors.black,
                                  dataLabelSettings: const DataLabelSettings(
                                      borderColor: Colors.white,
                                      textStyle: TextStyle(color: Colors.white),
                                      color: Colors.white),
                                )
                              ]),
                        ),
                        SfRadialGauge(
                            enableLoadingAnimation: true,
                            title: const GaugeTitle(
                                text: 'Air Quality Index',
                                textStyle: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                            axes: <RadialAxis>[
                              RadialAxis(
                                  minimum: 0,
                                  maximum: 500,
                                  ranges: <GaugeRange>[
                                    GaugeRange(
                                        label: "Excellent",
                                        startValue: 0,
                                        endValue: 50,
                                        color: Colors.blue,
                                        startWidth: 50,
                                        endWidth: 50),
                                    GaugeRange(
                                        label: "Good",
                                        startValue: 50,
                                        endValue: 100,
                                        color: Colors.green,
                                        startWidth: 50,
                                        endWidth: 50),
                                    GaugeRange(
                                        label: "Fair",
                                        startValue: 100,
                                        endValue: 150,
                                        color: Colors.yellow,
                                        startWidth: 50,
                                        endWidth: 50),
                                    GaugeRange(
                                        label: "Poor",
                                        startValue: 150,
                                        endValue: 200,
                                        color: Colors.orange,
                                        startWidth: 50,
                                        endWidth: 50),
                                    GaugeRange(
                                        label: "Un Healthy",
                                        startValue: 200,
                                        endValue: 300,
                                        color: Colors.purple,
                                        startWidth: 50,
                                        endWidth: 50),
                                    GaugeRange(
                                        label: "TOXIC",
                                        startValue: 300,
                                        endValue: 500,
                                        color: Colors.red,
                                        startWidth: 50,
                                        endWidth: 50),
                                  ],
                                  pointers: <GaugePointer>[
                                    NeedlePointer(
                                      value: double.parse(
                                          lastData.values.elementAt(14)),
                                      needleColor: Colors.white,
                                      enableAnimation: true,
                                      knobStyle: const KnobStyle(
                                          color: Colors.blueGrey),
                                    )
                                  ],
                                  annotations: [
                                    GaugeAnnotation(
                                      widget: Text(
                                        "AQI: ${lastData.values.elementAt(14)}",
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.white),
                                      ),
                                      positionFactor: 0.5,
                                      angle: 90,
                                    ),
                                  ])
                            ]),
                        const Text(
                          'Predicted AQI',
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        BlurryContainer(
                          blur: 50,
                          width: MediaQuery.of(context).size.width / 2.2,
                          height: MediaQuery.of(context).size.height / 9,
                          elevation: 10,
                          color: Colors.transparent,
                          padding: const EdgeInsets.all(8),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const Text(
                                  "Predicted",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                                Text(
                                  lastData.values.elementAt(17).toString(),
                                  style: const TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ]),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        const Text(
                          'Suggestions',
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        AQISugguestion(
                          aqi: int.parse(lastData.values.elementAt(14)),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        if (showMoreElements)
                          ShowMore(
                            lastData: lastData,
                            pm25: double.parse(lastData.values.elementAt(2)),
                            pm10: double.parse(lastData.values.elementAt(3)),
                            nO: double.parse(lastData.values.elementAt(4)),
                            nO2: double.parse(lastData.values.elementAt(5)),
                            nOx: double.parse(lastData.values.elementAt(6)),
                            nH3: double.parse(lastData.values.elementAt(7)),
                            cO: double.parse(lastData.values.elementAt(8)),
                            sO2: double.parse(lastData.values.elementAt(9)),
                            o3: double.parse(lastData.values.elementAt(10)),
                            benzene:
                                double.parse(lastData.values.elementAt(11)),
                            toulene:
                                double.parse(lastData.values.elementAt(12)),
                            xylene: double.parse(lastData.values.elementAt(13)),
                            aqi: double.parse(lastData.values.elementAt(14)),
                            aqiCategory: lastData.values.elementAt(15),
                            roomTemperature: lastData.values.elementAt(16),
                          ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              showMoreElements = !showMoreElements;
                            });
                          },
                          child: Text(
                            showMoreElements
                                ? "Hide Elements"
                                : "Show Elements",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 20),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    )
                  else
                    const CircularProgressIndicator()
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ShowMore extends StatelessWidget {
  ShowMore(
      {super.key,
      required this.lastData,
      required this.pm25,
      required this.pm10,
      required this.nO,
      required this.nO2,
      required this.nOx,
      required this.nH3,
      required this.cO,
      required this.sO2,
      required this.o3,
      required this.benzene,
      required this.toulene,
      required this.xylene,
      required this.aqi,
      required this.aqiCategory,
      required this.roomTemperature});

  final Map<String, dynamic> lastData;
  final double pm25,
      pm10,
      nO,
      nO2,
      nOx,
      nH3,
      cO,
      sO2,
      o3,
      benzene,
      toulene,
      xylene,
      aqi;
  var aqiCategory, roomTemperature;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 30,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: BlurryContainer(
              blur: 50,
              width: MediaQuery.of(context).size.width - 30,
              // height: MediaQuery.of(context).size.height / 9,
              elevation: 10,
              color: Colors.transparent,
              padding: const EdgeInsets.all(8),
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Room Temperature",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    Text(
                      roomTemperature + ' °C',
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ]),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: BlurryContainer(
              blur: 50,
              width: MediaQuery.of(context).size.width - 30,
              // height: MediaQuery.of(context).size.height / 9,
              elevation: 10,
              color: Colors.transparent,
              padding: const EdgeInsets.all(8),
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "PM 2.5",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  Text(
                    lastData.values.elementAt(2),
                    style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        overflow: TextOverflow.ellipsis),
                  ),
                  Row(
                    children: [
                      Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: sO2 > 0 && sO2 <= 50
                              ? Colors.blue
                              : sO2 > 50 && sO2 <= 100
                              ? Colors.green
                              : sO2 > 100 && sO2 <= 150
                              ? Colors.yellow
                              : sO2 > 150 && sO2 <= 200
                              ? Colors.orange
                              : sO2 > 200 && sO2 <= 300
                              ? Colors.purple
                              : Colors.red,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: Text(
                          pm25 > 0 && pm25 <= 50
                              ? 'Vacuum and dust frequently'
                              : pm25 > 50 && pm25 <= 100
                                  ? 'Invest in HEPA air filters for your HVAC system'
                                  : pm25 > 150 && pm25 <= 200
                                      ? 'Wear N95 respirators if available and safe to do so'
                                      : pm25 > 200 && pm25 <= 300
                                          ? 'Seal off the building if possible to contain the hazard'
                                          : 'Do not attempt to approach the building or surrounding area',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: BlurryContainer(
              blur: 50,
              width: double.infinity,
              elevation: 10,
              color: Colors.transparent,
              padding: const EdgeInsets.all(8),
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Pm 10",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    Text(
                      lastData.values.elementAt(3),
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    Row(
                      children: [
                        Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: sO2 > 0 && sO2 <= 50
                                ? Colors.blue
                                : sO2 > 50 && sO2 <= 100
                                ? Colors.green
                                : sO2 > 100 && sO2 <= 150
                                ? Colors.yellow
                                : sO2 > 150 && sO2 <= 200
                                ? Colors.orange
                                : sO2 > 200 && sO2 <= 300
                                ? Colors.purple
                                : Colors.red,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: Text(
                            pm10 > 0 && pm10 <= 50
                                ? 'Use doormats to trap outdoor particles	'
                                : pm10 > 50 && pm10 <= 100
                                    ? 'Invest in HEPA air filters for your HVAC system'
                                    : pm10 > 150 && pm10 <= 200
                                        ? 'Wear N95 respirators if available and safe to do so'
                                        : pm10 > 200 && pm10 <= 300
                                            ? 'Seal off the building if possible to contain the hazard'
                                            : 'Do not attempt to approach the building or surrounding area',
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    )
                  ]),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: BlurryContainer(
              blur: 50,
              width: double.infinity,
              elevation: 10,
              color: Colors.transparent,
              padding: const EdgeInsets.all(8),
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "NO",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    Text(
                      lastData.values.elementAt(4),
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    Row(
                      children: [
                        Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: sO2 > 0 && sO2 <= 50
                                ? Colors.blue
                                : sO2 > 50 && sO2 <= 100
                                ? Colors.green
                                : sO2 > 100 && sO2 <= 150
                                ? Colors.yellow
                                : sO2 > 150 && sO2 <= 200
                                ? Colors.orange
                                : sO2 > 200 && sO2 <= 300
                                ? Colors.purple
                                : Colors.red,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: Text(
                            nO > 0 && nO <= 50
                                ? 'Encourage non-smoking indoors'
                                : nO > 50 && nO <= 100
                                    ? 'Identify and address potential sources like gas appliances or off-gasing furniture'
                                    : nO > 150 && nO <= 200
                                        ? 'Wear N95 respirators if available and safe to do so'
                                        : nO > 200 && nO <= 300
                                            ? 'Seal off the building if possible to contain the hazard'
                                            : 'Do not attempt to approach the building or surrounding area',
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    )
                  ]),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: BlurryContainer(
              blur: 50,
              width: double.infinity,
              elevation: 10,
              color: Colors.transparent,
              padding: const EdgeInsets.all(8),
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "NO2",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    Text(
                      lastData.values.elementAt(5),
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    Row(
                      children: [
                        Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: sO2 > 0 && sO2 <= 50
                                ? Colors.blue
                                : sO2 > 50 && sO2 <= 100
                                ? Colors.green
                                : sO2 > 100 && sO2 <= 150
                                ? Colors.yellow
                                : sO2 > 150 && sO2 <= 200
                                ? Colors.orange
                                : sO2 > 200 && sO2 <= 300
                                ? Colors.purple
                                : Colors.red,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: Text(
                            nO2 > 0 && nO2 <= 50
                                ? 'Encourage non-smoking indoors'
                                : nO2 > 50 && nO2 <= 100
                                    ? 'Identify and address potential sources like gas appliances or off-gasing furniture'
                                    : nO2 > 150 && nO2 <= 200
                                        ? 'Wear N95 respirators if available and safe to do so'
                                        : nO2 > 200 && nO2 <= 300
                                            ? 'Seal off the building if possible to contain the hazard'
                                            : 'Do not attempt to approach the building or surrounding area',
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    )
                  ]),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: BlurryContainer(
              blur: 50,
              width: double.infinity,
              elevation: 10,
              color: Colors.transparent,
              padding: const EdgeInsets.all(8),
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "NOx",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    Text(
                      lastData.values.elementAt(6),
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    Row(
                      children: [
                        Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: sO2 > 0 && sO2 <= 50
                                ? Colors.blue
                                : sO2 > 50 && sO2 <= 100
                                ? Colors.green
                                : sO2 > 100 && sO2 <= 150
                                ? Colors.yellow
                                : sO2 > 150 && sO2 <= 200
                                ? Colors.orange
                                : sO2 > 200 && sO2 <= 300
                                ? Colors.purple
                                : Colors.red,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: Text(
                            nOx > 0 && nOx <= 50
                                ? 'Encourage non-smoking indoors'
                                : nOx > 50 && nOx <= 100
                                    ? 'Identify and address potential sources like gas appliances or off-gasing furniture'
                                    : nOx > 150 && nOx <= 200
                                        ? 'Wear N95 respirators if available and safe to do so'
                                        : nOx > 200 && nOx <= 300
                                            ? 'Seal off the building if possible to contain the hazard'
                                            : 'Do not attempt to approach the building or surrounding area',
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    )
                  ]),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: BlurryContainer(
              blur: 50,
              width: double.infinity,
              elevation: 10,
              color: Colors.transparent,
              padding: const EdgeInsets.all(8),
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "NH3",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    Text(
                      lastData.values.elementAt(7),
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    Row(
                      children: [
                        Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: sO2 > 0 && sO2 <= 50
                                ? Colors.blue
                                : sO2 > 50 && sO2 <= 100
                                ? Colors.green
                                : sO2 > 100 && sO2 <= 150
                                ? Colors.yellow
                                : sO2 > 150 && sO2 <= 200
                                ? Colors.orange
                                : sO2 > 200 && sO2 <= 300
                                ? Colors.purple
                                : Colors.red,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: Text(
                            nH3 > 0 && nH3 <= 50
                                ? 'Store cleaning products properly and avoid spills'
                                : nH3 > 50 && nH3 <= 100
                                    ? 'Ventilate bathrooms thoroughly after showers or baths'
                                    : nH3 > 150 && nH3 <= 200
                                        ? 'Turn off HVAC systems and fans to avoid spreading pollutants'
                                        : nH3 > 200 && nH3 <= 300
                                            ? 'Do not attempt to re-enter the space until declared safe by authorities'
                                            : 'Do not spread misinformation or rumors; rely on official sources for accurate information',
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    )
                  ]),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: BlurryContainer(
              blur: 50,
              width: double.infinity,
              elevation: 10,
              color: Colors.transparent,
              padding: const EdgeInsets.all(8),
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "CO",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    Text(
                      lastData.values.elementAt(8),
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    Row(
                      children: [
                        Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: sO2 > 0 && sO2 <= 50
                                ? Colors.blue
                                : sO2 > 50 && sO2 <= 100
                                ? Colors.green
                                : sO2 > 100 && sO2 <= 150
                                ? Colors.yellow
                                : sO2 > 150 && sO2 <= 200
                                ? Colors.orange
                                : sO2 > 200 && sO2 <= 300
                                ? Colors.purple
                                : Colors.red,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: Text(
                            cO > 0 && cO <= 50
                                ? 'Ensure proper functioning of gas appliances'
                                : cO > 50 && cO <= 100
                                    ? 'Check chimneys and vents for proper airflow'
                                    : cO > 150 && cO <= 200
                                        ? 'Turn off HVAC systems and fans to avoid spreading pollutants'
                                        : cO > 200 && cO <= 300
                                            ? 'Do not attempt to re-enter the space until declared safe by authorities'
                                            : 'Do not spread misinformation or rumors; rely on official sources for accurate information',
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    )
                  ]),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: BlurryContainer(
              blur: 50,
              width: double.infinity,
              elevation: 10,
              color: Colors.transparent,
              padding: const EdgeInsets.all(8),
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "SO2",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    Text(
                      lastData.values.elementAt(9),
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    Row(children: [
                      Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: sO2 > 0 && sO2 <= 50
                              ? Colors.blue
                              : sO2 > 50 && sO2 <= 100
                                  ? Colors.green
                                  : sO2 > 100 && sO2 <= 150
                                      ? Colors.yellow
                                      : sO2 > 150 && sO2 <= 200
                                          ? Colors.orange
                                          : sO2 > 200 && sO2 <= 300
                                              ? Colors.purple
                                              : Colors.red,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: Text(
                          sO2 > 0 && sO2 <= 50
                              ? 'Avoid burning candles or incense indoors	'
                              : sO2 > 50 && sO2 <= 100
                                  ? 'Avoid using aerosol sprays indoors'
                                  : sO2 > 150 && sO2 <= 200
                                      ? 'Turn off HVAC systems and fans to avoid spreading pollutants'
                                      : sO2 > 200 && sO2 <= 300
                                          ? 'Do not attempt to re-enter the space until declared safe by authorities'
                                          : 'Do not spread misinformation or rumors; rely on official sources for accurate information',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ]),
                  ]),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: BlurryContainer(
              blur: 50,
              width: double.infinity,
              elevation: 10,
              color: Colors.transparent,
              padding: const EdgeInsets.all(8),
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "O3",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    Text(
                      lastData.values.elementAt(10),
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    Row(children: [
                      Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: sO2 > 0 && sO2 <= 50
                              ? Colors.blue
                              : sO2 > 50 && sO2 <= 100
                              ? Colors.green
                              : sO2 > 100 && sO2 <= 150
                              ? Colors.yellow
                              : sO2 > 150 && sO2 <= 200
                              ? Colors.orange
                              : sO2 > 200 && sO2 <= 300
                              ? Colors.purple
                              : Colors.red,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: Text(
                          o3 > 0 && o3 <= 50
                              ? 'Avoid using ozone generators indoors'
                              : o3 > 50 && o3 <= 100
                                  ? 'Close windows during peak ozone hours	'
                                  : o3 > 150 && o3 <= 200
                                      ? 'Turn off HVAC systems and fans to avoid spreading pollutants'
                                      : o3 > 200 && o3 <= 300
                                          ? 'Do not attempt to re-enter the space until declared safe by authorities'
                                          : 'Do not spread misinformation or rumors; rely on official sources for accurate information',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ])
                  ]),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: BlurryContainer(
              blur: 50,
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 9,
              elevation: 10,
              color: Colors.transparent,
              padding: const EdgeInsets.all(8),
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Benzene",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    Text(
                      lastData.values.elementAt(11),
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    Row(children: [
                      Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: sO2 > 0 && sO2 <= 50
                              ? Colors.blue
                              : sO2 > 50 && sO2 <= 100
                              ? Colors.green
                              : sO2 > 100 && sO2 <= 150
                              ? Colors.yellow
                              : sO2 > 150 && sO2 <= 200
                              ? Colors.orange
                              : sO2 > 200 && sO2 <= 300
                              ? Colors.purple
                              : Colors.red,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: Text(
                          benzene > 0 && benzene <= 50
                              ? 'Opt for natural furniture materials with low VOCs'
                              : benzene > 50 && benzene <= 100
                                  ? 'Store paints, solvents, and other chemicals safely'
                                  : benzene > 150 && benzene <= 200
                                      ? 'Turn off HVAC systems and fans to avoid spreading pollutants'
                                      : benzene > 200 && benzene <= 300
                                          ? 'Do not attempt to re-enter the space until declared safe by authorities'
                                          : 'Do not spread misinformation or rumors; rely on official sources for accurate information',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ]),
                  ]),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: BlurryContainer(
              blur: 50,
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 9,
              elevation: 10,
              color: Colors.transparent,
              padding: const EdgeInsets.all(8),
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Toulene",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    Text(
                      lastData.values.elementAt(12),
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    Row(children: [
                      Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: sO2 > 0 && sO2 <= 50
                              ? Colors.blue
                              : sO2 > 50 && sO2 <= 100
                              ? Colors.green
                              : sO2 > 100 && sO2 <= 150
                              ? Colors.yellow
                              : sO2 > 150 && sO2 <= 200
                              ? Colors.orange
                              : sO2 > 200 && sO2 <= 300
                              ? Colors.purple
                              : Colors.red,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: Text(
                          toulene > 0 && toulene <= 50
                              ? 'Opt for natural furniture materials with low VOCs'
                              : toulene > 50 && toulene <= 100
                                  ? 'Store paints, solvents, and other chemicals safely'
                                  : toulene > 150 && toulene <= 200
                                      ? 'Turn off HVAC systems and fans to avoid spreading pollutants'
                                      : toulene > 200 && toulene <= 300
                                          ? 'Do not attempt to re-enter the space until declared safe by authorities'
                                          : 'Do not spread misinformation or rumors; rely on official sources for accurate information',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ]),
                  ]),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: BlurryContainer(
              blur: 50,
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 9,
              elevation: 10,
              color: Colors.transparent,
              padding: const EdgeInsets.all(8),
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Xylene",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    Text(
                      lastData.values.elementAt(13),
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    Row(children: [
                      Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: sO2 > 0 && sO2 <= 50
                              ? Colors.blue
                              : sO2 > 50 && sO2 <= 100
                              ? Colors.green
                              : sO2 > 100 && sO2 <= 150
                              ? Colors.yellow
                              : sO2 > 150 && sO2 <= 200
                              ? Colors.orange
                              : sO2 > 200 && sO2 <= 300
                              ? Colors.purple
                              : Colors.red,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: Text(
                          xylene > 0 && xylene <= 50
                              ? 'Opt for natural furniture materials with low VOCs'
                              : xylene > 50 && xylene <= 100
                                  ? 'Store paints, solvents, and other chemicals safely'
                                  : xylene > 150 && xylene <= 200
                                      ? 'Turn off HVAC systems and fans to avoid spreading pollutants'
                                      : xylene > 200 && xylene <= 300
                                          ? 'Do not attempt to re-enter the space until declared safe by authorities'
                                          : 'Do not spread misinformation or rumors; rely on official sources for accurate information',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ]),
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}

class AQISugguestion extends StatelessWidget {
  const AQISugguestion({super.key, required this.aqi});

  final aqi;

  @override
  Widget build(BuildContext context) {
    return BlurryContainer(
      blur: 50,
      width: MediaQuery.of(context).size.width - 30,
      // height: MediaQuery.of(context).size.height / 9,
      elevation: 10,
      color: Colors.transparent,
      padding: const EdgeInsets.all(20),
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              child: Column(
                children: [
                  const Icon(
                    Icons.air_outlined,
                    color: Colors.white,
                    size: 40,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Air Purifier",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  Text(
                    aqi > 150 ? "Required" : "Not Required",
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  const Icon(
                    Icons.cleaning_services_outlined,
                    color: Colors.white,
                    size: 40,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Cleaning",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  Text(
                    aqi > 100 ? "Required" : "Not Required",
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ],
              ),
            )
          ],
        ),
        const SizedBox(
          height: 40,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                const Icon(
                  Icons.masks_outlined,
                  color: Colors.white,
                  size: 45,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Pollution Mask",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                Text(
                  aqi > 150 ? "Required" : "Not Required",
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
              ],
            ),
            Container(
              child: Column(
                children: [
                  const Icon(
                    Icons.inventory_2_outlined,
                    color: Colors.white,
                    size: 40,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Ventilation",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  Text(
                    aqi > 150 ? "Required" : "Not Required",
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ],
              ),
            )
          ],
        ),
        const SizedBox(
          height: 40,
        ),
        const Column(
          children: [
            Icon(
              Icons.family_restroom_outlined,
              color: Colors.white,
              size: 45,
            ),
            SizedBox(height: 20),
            Text(
              "Exercise",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            Text(
              'Suitable for Indoor Activities',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ],
        ),
      ]),
    );
  }
}
