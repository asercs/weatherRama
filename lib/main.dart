import 'data_service.dart';
import 'package:flutter/material.dart';
import 'models.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _cityTextController = TextEditingController();
  final _dataService = DataService();

  WeatherResponse _response;
  AssetsAudioPlayer _assetsAudioPlayer;

  @override
  void initState() {
    super.initState();
    _assetsAudioPlayer = AssetsAudioPlayer();
    _assetsAudioPlayer.open(
      Playlist(audios: [
        Audio('lib/Rain.mp3'),
        Audio('lib/Clear.mp3'),
        Audio('lib/Thunderstorm.mp3'),
        Audio('lib/Drizzle.mp3'),
        Audio('lib/Snow.mp3'),
        Audio('lib/Atmosphere.mp3'),
        Audio('lib/Clouds.mp3'),
      ]),
      autoStart: false,
      loopMode: LoopMode.single,
    );
  }

  @override
  void dispose() {
    _assetsAudioPlayer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("lib/background.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            onPressed: () {
                              _assetsAudioPlayer.playOrPause();
                            },
                            icon: Icon(Icons.music_note_outlined),
                            iconSize: 35),
                      ],
                    ),
                    if (_response != null)
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 70, 0, 0),
                        child: Column(
                          children: [
                            Text(_response.cityName,
                                style: GoogleFonts.josefinSans(
                                    fontSize: 45, fontWeight: FontWeight.bold)),
                            Image.network(_response.iconUrl),
                            Text('${_response.tempInfo.temperature}°',
                                style: GoogleFonts.josefinSans(
                                    fontSize: 45, fontWeight: FontWeight.bold)),
                            Text(
                              '💧' +
                                  '${_response.humidInfo.humidity}%   ' +
                                  '💨' +
                                  '${_response.windInfo.wind} m/s',
                              style: GoogleFonts.josefinSans(fontSize: 25),
                            ),
                            Text(
                              _response.weatherInfo.description,
                              style: GoogleFonts.josefinSans(fontSize: 20),
                            ),
                          ],
                        ),
                      ),

                    Spacer(
                      flex: 2,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 50),
                      child: SizedBox(
                        width: 250,
                        child: TextField(
                            style: GoogleFonts.josefinSans(
                                fontSize: 25, color: Colors.white),
                            controller: _cityTextController,
                            decoration: InputDecoration(
                                prefixIcon: IconButton(
                                  onPressed: _city,
                                  icon: Icon(Icons.location_on),
                                ),
                                suffixIcon: IconButton(
                                  onPressed: _search,
                                  icon: Icon(Icons.search),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                labelText: 'City',
                                labelStyle:
                                    GoogleFonts.josefinSans(fontSize: 20)),
                            textAlign: TextAlign.center),
                      ),
                    ),
                    // ElevatedButton(onPressed: _search, child: Text('Search'))
                  ],
                ),
              ),
            )));
  }

  void playSong(String group) {
    if (_response.weatherInfo.main == 'Rain') {
      _assetsAudioPlayer.playlistPlayAtIndex(0);
    } else if (_response.weatherInfo.main == 'Clear') {
      _assetsAudioPlayer.playlistPlayAtIndex(1);
    } else if (_response.weatherInfo.main == 'Thunderstorm') {
      _assetsAudioPlayer.playlistPlayAtIndex(2);
    } else if (_response.weatherInfo.main == 'Drizzle') {
      _assetsAudioPlayer.playlistPlayAtIndex(3);
    } else if (_response.weatherInfo.main == 'Snow') {
      _assetsAudioPlayer.playlistPlayAtIndex(4);
    } else if (_response.weatherInfo.main == 'Atmosphere') {
      _assetsAudioPlayer.playlistPlayAtIndex(5);
    } else if (_response.weatherInfo.main == 'Clouds') {
      _assetsAudioPlayer.playlistPlayAtIndex(6);
    }
  }

  void _search() async {
    final response = await _dataService.getWeather(_cityTextController.text);
    setState(() => _response = response);
    playSong(_response.weatherInfo.main);
  }

  void _city() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    final response = await _dataService.getWeatherByCoor(
        position.latitude.toString(), position.longitude.toString());
    setState(() => _response = response);
    playSong(_response.weatherInfo.main);
  }
}
