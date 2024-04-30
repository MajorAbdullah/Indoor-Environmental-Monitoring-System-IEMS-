// ignore_for_file: avoid_print
import 'package:flutter/cupertino.dart';
import 'package:iems/screens/current_analysis.dart';
import 'package:iems/screens/onboding/components/about_screen.dart';
import 'package:iems/screens/user_profile.dart';
import 'package:smart_listview_builder/smart_listview_builder.dart';

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_horizontal_featured_list/flutter_horizontal_featured_list.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:rive/rive.dart';
import 'package:ionicons/ionicons.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  Future<Map<String, dynamic>> fetchWeatherData() async {
    final response = await http.get(Uri.parse(
        'http://api.weatherapi.com/v1/forecast.json?key=93d7ec24bff6448085a64137242201&q=Lahore&days=8&aqi=yes&alerts=no'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  @override
  late RiveAnimationController _btnAnimationController;
  int activeIndex = 0;
  @override
  void initState() {
    _btnAnimationController = OneShotAnimation("active", autoplay: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.flip,
        items: const[
          TabItem(icon: Icons.analytics, title: "Indoor Analysis"),
          // TabItem(icon: Icons.calendar_month, title: "Prediction Analysis"),
          TabItem(icon: Ionicons.cloud, title: "Weather"),
          TabItem(icon: Icons.person, title: "My Profile"),
          TabItem(icon: CupertinoIcons.info, title: "About Us"),
        ],
        initialActiveIndex: 0,
        onTap: (int i) {
          print('click index=$i');
          setState(() {
            activeIndex = i;
          });
        },
      ),
      backgroundColor: Colors.transparent,
      body: Stack(
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
          if (activeIndex == 0)
            const CurrentAnalysis()
          else if (activeIndex == 1)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 240),
              top: 0,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: FutureBuilder<Map<String, dynamic>>(
                    future: fetchWeatherData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData) {
                        return const Center(child: Text('No data available'));
                      }

                      final location = snapshot.data!['location'];
                      final current = snapshot.data!['current'];
                      final forecast = snapshot.data!['forecast'];

                      final cityName = location['name'];
                      final currentTemperature = current['temp_c'].toDouble();
                      final maxTemperature = forecast['forecastday'][0]['day']
                              ['maxtemp_c']
                          .toDouble(); // Replace with actual data
                      final minTemperature = forecast['forecastday'][0]['day']
                              ['mintemp_c']
                          .toDouble(); // Replace with actual data
                      final weatherDescription = current['condition']['text'];
                      final updatedAt = current['last_updated'];

                      return MainInfoWidget(
                        curr_data: current,
                        data: forecast,
                        updatedAt: updatedAt,
                        cityName: cityName,
                        currentTemperature: currentTemperature,
                        maxTemperature: maxTemperature,
                        minTemperature: minTemperature,
                        weatherDescription: weatherDescription,
                      );
                    },
                  ),
                ),
              ),
            )
          else if (activeIndex == 2)
            const UserProfile()
          else if(activeIndex == 3)
            const AboutScreen()
        ],
      ),
    );
  }
}

class MainInfoWidget extends StatelessWidget {
  final String cityName;
  final double currentTemperature;
  final double maxTemperature;
  final double minTemperature;
  final String weatherDescription;
  final String updatedAt;
  final dynamic data;
  final dynamic curr_data;

  MainInfoWidget(
      {super.key, required this.cityName,
      required this.currentTemperature,
      required this.maxTemperature,
      required this.minTemperature,
      required this.updatedAt,
      required this.weatherDescription,
      required this.data,
      required this.curr_data});
  List<Color> colors = List.generate(7, (index) => randomColor());

  @override
  Widget build(BuildContext context) {
    print(colors);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 16.0,
          bottom: 16.0,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                "Current Weather".toUpperCase(),
                style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    letterSpacing: 5,
                    fontSize: 25.0,
                    color: Colors.white),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text(
                'in',
                maxLines: 1,
                style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.w100,
                    color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                cityName.toUpperCase(),
                style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    letterSpacing: 5,
                    fontSize: 20.0,
                    color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                '${currentTemperature.round()}°',
                maxLines: 1,
                style: const TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.w100,
                    color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Icon(
                    Icons.keyboard_arrow_up,
                    size: 24.0,
                    color: Colors.white,
                  ),
                  Text(
                    '${maxTemperature.round()}°',
                    style: const TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      size: 24.0,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '${minTemperature.round()}°',
                    style: const TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                ],
              ),
            ),
            Text(
              weatherDescription.toUpperCase(),
              style: const TextStyle(
                  fontWeight: FontWeight.w300,
                  letterSpacing: 5,
                  fontSize: 15.0,
                  color: Colors.white),
            ),
            HorizontalFeaturedList(
              itemHeight: MediaQuery.of(context).size.height / 5,
              itemColorBuilder: (context, index) => colors[index],
              itemCount: colors.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    Row(
                      children: <Widget>[
                        const Icon(
                          Icons.alarm,
                          size: 24,
                          color: Colors.black,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              data['forecastday'][index]['hour'][index]['time']
                                  .toString()
                                  .split(" ")[1],
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        Image.network(
                            "http:" +
                                data['forecastday'][index]['hour'][index]
                                    ['condition']['icon'],
                            scale: 1.2),
                      ],
                    ),
                    Row(
                      children: [
                        SvgPicture.asset('assets/weather/max_temp.svg'),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              data['forecastday'][index]['hour'][index]
                                      ['temp_c']
                                  .toString(),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        // SvgPicture.asset('assets/weather/max_temp.svg'),
                        const Icon(
                          Icons.water_drop_outlined,
                          color: Colors.black,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "${data['forecastday'][index]['hour'][index]
                                          ['chance_of_rain']}%",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
              onPressedItem: () {
                print(data['forecastday'][1]['day']['condition']['icon']);
              },
              onPressedSeeAll: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ApiHourly(
                        data: data['forecastday'][0]['hour'],
                      ),
                    ));
              },
              titleText: 'Hourly Forecast',
              titleTextStyle: const TextStyle(color: Colors.white),
              seeAllText: 'See All',
              seeAllTextStyle: const TextStyle(color: Colors.white),
            ),
            HorizontalFeaturedList(
              itemHeight: MediaQuery.of(context).size.height / 5,
              itemColorBuilder: (context, index) => colors[index],
              itemCount: colors.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    Row(
                      children: <Widget>[
                        const Icon(
                          Icons.calendar_month,
                          size: 24,
                          color: Colors.black,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              data['forecastday'][index + 1]['date'].toString(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Image.network(
                            "http:" +
                                data['forecastday'][index + 1]['day']
                                    ['condition']['icon'],
                            scale: 1.2),
                      ],
                    ),
                    Row(
                      children: [
                        SvgPicture.asset('assets/weather/max_temp.svg'),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              data['forecastday'][index + 1]['day']['maxtemp_c']
                                  .toString(),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SvgPicture.asset('assets/weather/min_temp.svg'),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              data['forecastday'][index + 1]['day']['mintemp_c']
                                  .toString(),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
              onPressedItem: () {
                print(data['forecastday'][0]['day']['air_quality']['pm2_5']);
              },
              onPressedSeeAll: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ApiDaily(data: data['forecastday']),
                    ));
              },
              titleText: 'Weekly Forecast',
              titleTextStyle: const TextStyle(color: Colors.white),
              seeAllText: 'See All',
              seeAllTextStyle: const TextStyle(color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 100),
              child: SfRadialGauge(
                  enableLoadingAnimation: true,
                  title: const GaugeTitle(
                      text: 'Air Quality Index',
                      textStyle: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  axes: <RadialAxis>[
                    RadialAxis(minimum: 0, maximum: 300, ranges: <GaugeRange>[
                      GaugeRange(
                          label: "Excellent",
                          startValue: 0,
                          endValue: 33,
                          color: Colors.blue,
                          startWidth: 50,
                          endWidth: 50),
                      GaugeRange(
                          label: "Good",
                          startValue: 34,
                          endValue: 66,
                          color: Colors.green,
                          startWidth: 50,
                          endWidth: 50),
                      GaugeRange(
                          label: "Fair",
                          startValue: 67,
                          endValue: 99,
                          color: Colors.yellow,
                          startWidth: 50,
                          endWidth: 50),
                      GaugeRange(
                          label: "Poor",
                          startValue: 100,
                          endValue: 149,
                          color: Colors.orange,
                          startWidth: 50,
                          endWidth: 50),
                      GaugeRange(
                          label: "Very Poor",
                          startValue: 150,
                          endValue: 200,
                          color: Colors.purple,
                          startWidth: 50,
                          endWidth: 50),
                      GaugeRange(
                          label: "TOXIC",
                          startValue: 201,
                          endValue: 500,
                          color: Colors.red,
                          startWidth: 50,
                          endWidth: 50),
                    ], pointers: <GaugePointer>[
                      NeedlePointer(
                        value: curr_data['air_quality']['pm2_5'],
                        needleColor: Colors.white,
                        knobStyle: const KnobStyle(color: Colors.blueGrey),
                      )
                    ], annotations: const <GaugeAnnotation>[])
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}

Color randomColor() {
  return const Color.fromARGB(26, 35, 126, 1);
}

class ApiHourly extends StatelessWidget {
  final dynamic data;
  const ApiHourly({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    print(data[23]);
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          'Hourly Forecast',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
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
          AnimatedPositioned(
            duration: const Duration(milliseconds: 240),
            top: 0,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: const Text(""),
          ),
          SmartListViewBuilder(
            physics: const BouncingScrollPhysics(),
            addAutomaticKeepAlives: true,
            addRepaintBoundaries: true,
            itemCount: 24,
            reverse: false,
            itemBuilder: (BuildContext content, int index) {
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: BlurryContainer(
                  blur: 50,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 2.5,
                  elevation: 10,
                  color: Colors.transparent,
                  padding: const EdgeInsets.all(8),
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(
                            Icons.alarm,
                            color: Colors.white,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              data[index]['time'].toString().split(" ")[1],
                              style: const TextStyle(
                                  fontSize: 25, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(
                            Icons.thermostat,
                            color: Colors.white,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              data[index]['temp_c'].toString(),
                              style: const TextStyle(
                                  fontSize: 25, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              data[index]['condition']['text'].toString(),
                              style: const TextStyle(
                                  fontSize: 25, color: Colors.white),
                            ),
                          ),
                          Image.network(
                              "http:" + data[index]['condition']['icon'],
                              scale: 1.2),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.wind_power,
                            color: Colors.white,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "${data[index]['wind_kph']} km/h towards ${data[index]['wind_dir']}",
                              style: const TextStyle(
                                  fontSize: 25, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "${data[index]['cloud']} clouds with chance of rain: ${data[index]['chance_of_rain']}%",
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

class ApiDaily extends StatelessWidget {
  final dynamic data;

  const ApiDaily({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          'Weekly Forecast',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
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
          AnimatedPositioned(
            duration: const Duration(milliseconds: 240),
            top: 0,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: const Text(""),
          ),
          SmartListViewBuilder(
            physics: const BouncingScrollPhysics(),
            addAutomaticKeepAlives: true,
            addRepaintBoundaries: true,
            itemCount: 7,
            reverse: false,
            itemBuilder: (BuildContext content, int index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: BlurryContainer(
                  blur: 50,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 2.1,
                  elevation: 10,
                  color: Colors.transparent,
                  padding: const EdgeInsets.all(8),
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(
                            Icons.alarm,
                            color: Colors.white,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              data[index]['date'].toString(),
                              style: const TextStyle(
                                  fontSize: 25, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(
                            Icons.thermostat,
                            color: Colors.white,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              data[index]['day']['maxtemp_c'].toString(),
                              style: const TextStyle(
                                  fontSize: 25, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              data[index]['day']['condition']['text']
                                  .toString(),
                              style: const TextStyle(
                                  fontSize: 25, color: Colors.white),
                            ),
                          ),
                          Image.network(
                              "http:" + data[index]['day']['condition']['icon'],
                              scale: 1.2),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(
                            Icons.wind_power,
                            color: Colors.white,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "${data[index]['day']['maxwind_kph']} km/h",
                              style: const TextStyle(
                                  fontSize: 25, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Chance of rain : ${data[index]['day']['daily_chance_of_rain']}%",
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Visibility Range : ${data[index]['day']['avgvis_km']} km",
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
