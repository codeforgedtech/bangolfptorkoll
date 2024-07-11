import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(BangolfApp());
}

class BangolfApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bangolf Protokoll',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          elevation: 0,
        ),
      ),
      home: SplashScreen(), // Visar splash screen först
    );
  }
}

class AppColors {
  static const Color primaryColor = Color.fromARGB(255, 88, 161, 33);
  static const Color secondaryColor = Color.fromARGB(255, 186, 218, 85);
  static const Color backgroundColor = Color.fromARGB(255, 248, 230, 174);
  static const Color textColor = Colors.white;
  static const Color cardColor = Color.fromARGB(255, 186, 218, 85);
  static const Color textFieldFillColor = Color.fromARGB(255, 248, 230, 174);
  static const Color sliderActiveColor = Color.fromARGB(255, 88, 161, 33);
  static const Color sliderInactiveColor = Color.fromARGB(255, 248, 230, 174);
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isLoading = false; // För att hålla reda på om laddaren ska visas

  @override
  void initState() {
    super.initState();
    // Visa laddaren direkt när skärmen laddas
    _isLoading = true;
    // Simulera en laddning med en fördröjning på 2 sekunder
    Timer(Duration(seconds: 2), () {
      setState(() {
        _isLoading = false; // Sluta visa laddaren när laddningen är klar
        // Ersätt splashskärmen med PlayerSelectionScreen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => PlayerSelectionScreen(),
          ),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cardColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logobangolfsplash.png',
              width: 200,
            ),
            SizedBox(
                height: 20), // Lite mellanrum mellan logotypen och laddaren
            if (_isLoading) // Visa laddaren om _isLoading är true
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
          ],
        ),
      ),
    );
  }
}

class PlayerSelectionScreen extends StatefulWidget {
  @override
  _PlayerSelectionScreenState createState() => _PlayerSelectionScreenState();
}

class _PlayerSelectionScreenState extends State<PlayerSelectionScreen> {
  int _playerCount = 1;

  void _nextStep() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlayerNameScreen(playerCount: _playerCount),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Välj antal spelare'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            color: AppColors.cardColor,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Antal spelare: $_playerCount',
                    style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor),
                  ),
                  SizedBox(height: 20.0),
                  Slider(
                    value: _playerCount.toDouble(),
                    min: 1,
                    max: 10,
                    divisions: 9,
                    label: _playerCount.toString(),
                    onChanged: (value) {
                      setState(() {
                        _playerCount = value.toInt();
                      });
                    },
                    activeColor: AppColors.sliderActiveColor,
                    inactiveColor: AppColors.sliderInactiveColor,
                  ),
                  SizedBox(height: 40.0),
                  ElevatedButton(
                    onPressed: _nextStep,
                    style: ElevatedButton.styleFrom(
                      primary: AppColors.primaryColor,
                      padding: EdgeInsets.symmetric(
                          horizontal: 32.0, vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      'Nästa',
                      style:
                          TextStyle(fontSize: 20.0, color: AppColors.textColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PlayerNameScreen extends StatefulWidget {
  final int playerCount;

  PlayerNameScreen({required this.playerCount});

  @override
  _PlayerNameScreenState createState() => _PlayerNameScreenState();
}

class _PlayerNameScreenState extends State<PlayerNameScreen> {
  final List<TextEditingController> _controllers = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.playerCount; i++) {
      _controllers.add(TextEditingController());
    }
  }

  void _nextStep() {
    bool allPlayersNamed =
        _controllers.every((controller) => controller.text.isNotEmpty);
    if (!allPlayersNamed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Vänligen ange namn för alla spelare.'),
        ),
      );
      return;
    }

    List<String> playerNames =
        _controllers.map((controller) => controller.text).toList();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RoundSelectionScreen(playerNames: playerNames),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ange spelarnamn'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          color: AppColors.cardColor,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: widget.playerCount,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32.0, vertical: 16.0),
                      child: TextField(
                        controller: _controllers[index],
                        decoration: InputDecoration(
                          labelText: 'Spelare ${index + 1}',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: AppColors.textFieldFillColor,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppColors.cardColor,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppColors.primaryColor,
                              width: 2.0,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: _nextStep,
                  style: ElevatedButton.styleFrom(
                    primary: AppColors.primaryColor,
                    padding:
                        EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'Nästa',
                    style:
                        TextStyle(fontSize: 20.0, color: AppColors.textColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RoundSelectionScreen extends StatefulWidget {
  final List<String> playerNames;

  RoundSelectionScreen({required this.playerNames});

  @override
  _RoundSelectionScreenState createState() => _RoundSelectionScreenState();
}

class _RoundSelectionScreenState extends State<RoundSelectionScreen> {
  int _roundCount = 1;

  void _nextStep() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProtocolScreen(
          playerNames: widget.playerNames,
          roundCount: _roundCount,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Välj antal varv'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            color: AppColors.cardColor,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Antal varv: $_roundCount',
                    style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor),
                  ),
                  SizedBox(height: 20.0),
                  Slider(
                    value: _roundCount.toDouble(),
                    min: 1,
                    max: 10,
                    divisions: 9,
                    label: _roundCount.toString(),
                    onChanged: (value) {
                      setState(() {
                        _roundCount = value.toInt();
                      });
                    },
                    activeColor: AppColors.sliderActiveColor,
                    inactiveColor: AppColors.sliderInactiveColor,
                  ),
                  SizedBox(height: 40.0),
                  ElevatedButton(
                    onPressed: _nextStep,
                    style: ElevatedButton.styleFrom(
                      primary: AppColors.primaryColor,
                      padding: EdgeInsets.symmetric(
                          horizontal: 32.0, vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      'Nästa',
                      style:
                          TextStyle(fontSize: 20.0, color: AppColors.textColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProtocolScreen extends StatefulWidget {
  final List<String> playerNames;
  final int roundCount;

  ProtocolScreen({required this.playerNames, required this.roundCount});

  @override
  _ProtocolScreenState createState() => _ProtocolScreenState();
}

class _ProtocolScreenState extends State<ProtocolScreen> {
  final List<List<List<int>>> _scores = [];
  final List<TextEditingController> _courseNameControllers = [];
  PageController _pageController = PageController();
  int _currentPage = 0;
  int _currentHolePage = 0;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.playerNames.length; i++) {
      _scores.add(
          List.generate(widget.roundCount, (_) => List.generate(18, (_) => 0)));
    }
    for (int i = 0; i < widget.roundCount; i++) {
      _courseNameControllers.add(TextEditingController());
    }
  }

  void _updateScore(int playerIndex, int roundIndex, int holeIndex, int value) {
    setState(() {
      _scores[playerIndex][roundIndex][holeIndex] = value;
    });
  }

  void _nextPage() {
    if (_currentPage < widget.roundCount - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 500),
        curve: Curves.ease,
      );
      setState(() {
        _currentPage++;
      });
    }
  }

  void _showStatistics(int roundIndex) {
    int totalScores = 0;
    List<int> totalScoresPerPlayer = List.filled(widget.playerNames.length, 0);
    List<int> spikes = List.filled(widget.playerNames.length, 0);
    List<double> averagePerHole = _calculateAveragePerHole(roundIndex);

    for (int playerIndex = 0;
        playerIndex < widget.playerNames.length;
        playerIndex++) {
      for (int score in _scores[playerIndex][roundIndex]) {
        totalScoresPerPlayer[playerIndex] += score;
        if (score == 1) {
          spikes[playerIndex]++;
        }
      }
      totalScores += totalScoresPerPlayer[playerIndex];
    }

    double averageScore = totalScores / (widget.playerNames.length * 18);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Statistik för varv ${roundIndex + 1}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              for (int playerIndex = 0;
                  playerIndex < widget.playerNames.length;
                  playerIndex++)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.playerNames[playerIndex]}: ${totalScoresPerPlayer[playerIndex]} slag',
                      style: TextStyle(
                          fontSize: 18.0,
                          color: const Color.fromARGB(255, 0, 0, 0)),
                    ),
                    Text(
                      'Spikar: ${spikes[playerIndex]}',
                      style: TextStyle(
                          fontSize: 16.0,
                          color: const Color.fromARGB(255, 0, 0, 0)),
                    ),
                    Text(
                      'Genomsnittligt antal slag per hål: ${averagePerHole[playerIndex].toStringAsFixed(2)}',
                      style: TextStyle(
                          fontSize: 16.0,
                          color: const Color.fromARGB(255, 0, 0, 0)),
                    ),
                    SizedBox(height: 8.0),
                  ],
                ),
              SizedBox(height: 16.0),
              Text(
                'Genomsnittligt antal slag för alla spelare: ${averageScore.toStringAsFixed(2)}',
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 0, 0, 0)),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Stäng',
                  style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0))),
            ),
          ],
        );
      },
    );
  }

  List<double> _calculateAveragePerHole(int roundIndex) {
    List<double> averages = [];

    for (int playerIndex = 0;
        playerIndex < widget.playerNames.length;
        playerIndex++) {
      double totalScore = 0;
      for (int holeIndex = 0; holeIndex < 18; holeIndex++) {
        totalScore += _scores[playerIndex][roundIndex][holeIndex];
      }
      double average = totalScore / 18;
      averages.add(average);
    }

    return averages;
  }

  void _saveProtocol() {
    bool allCoursesNamed = _courseNameControllers
        .every((controller) => controller.text.isNotEmpty);
    bool allPlayersNamed = widget.playerNames.every((name) => name.isNotEmpty);

    if (!allCoursesNamed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Vänligen ange namn för alla banor.'),
        ),
      );
      return;
    }

    if (!allPlayersNamed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Vänligen ange namn för alla spelare.'),
        ),
      );
      return;
    }

    print('Banor:');
    for (int i = 0; i < widget.roundCount; i++) {
      print('Banans namn för varv ${i + 1}: ${_courseNameControllers[i].text}');
      for (int j = 0; j < widget.playerNames.length; j++) {
        print('Resultat för ${widget.playerNames[j]}: ${_scores[j][i]}');
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Protokollet har sparats.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.roundCount,
        itemBuilder: (context, roundIndex) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              color: AppColors.cardColor,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            'Varv ${roundIndex + 1}',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textColor,
                            ),
                          ),
                          SizedBox(height: 10.0),
                          TextField(
                            controller: _courseNameControllers[roundIndex],
                            decoration: InputDecoration(
                              labelText: 'Ange banans namn',
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: AppColors.textFieldFillColor,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: AppColors.textColor,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: AppColors.primaryColor,
                                  width: 2.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Card(
                        color: AppColors.cardColor,
                        elevation: 4,
                        child: Column(
                          children: [
                            if (_currentHolePage == 0) ...[
                              _buildHoleTable(roundIndex, 0, 9),
                              SizedBox(height: 8.0),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _currentHolePage = 1;
                                  });
                                },
                                child: Text(
                                  '10 - 18',
                                  style: TextStyle(
                                    color: AppColors.textColor,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ] else ...[
                              _buildHoleTable(roundIndex, 9, 18),
                              SizedBox(height: 8.0),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _currentHolePage = 0;
                                  });
                                },
                                child: Text(
                                  '1 - 9',
                                  style: TextStyle(
                                    color: AppColors.textColor,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPage,
        onTap: (index) {
          setState(() {
            _currentPage = index;
            _pageController.animateToPage(
              _currentPage,
              duration: Duration(milliseconds: 500),
              curve: Curves.ease,
            );
          });
        },
        items: List.generate(
          widget.roundCount,
          (index) => BottomNavigationBarItem(
            icon: Icon(Icons.sports_golf, color: AppColors.primaryColor),
            label: 'Varv ${index + 1}',
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primaryColor,
        onPressed: () => _showStatistics(_currentPage),
        label: SizedBox.shrink(),
        icon: Icon(Icons.bar_chart, color: AppColors.textColor),
      ),
    );
  }

  Widget _buildHoleTable(int roundIndex, int startHole, int endHole) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 20.0,
        columns: [
          DataColumn(
            label: Text(
              'Bana',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 0, 0, 0),
              ),
            ),
          ),
          for (int playerIndex = 0;
              playerIndex < widget.playerNames.length;
              playerIndex++)
            DataColumn(
              label: Text(
                widget.playerNames[playerIndex],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            ),
        ],
        rows: [
          for (int holeIndex = startHole; holeIndex < endHole; holeIndex++)
            DataRow(
              cells: [
                DataCell(
                  Text(
                    'Bana ${holeIndex + 1}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                ),
                for (int playerIndex = 0;
                    playerIndex < widget.playerNames.length;
                    playerIndex++)
                  DataCell(
                    DropdownButton<int>(
                      value: _scores[playerIndex][roundIndex][holeIndex],
                      items: List.generate(
                        8,
                        (score) => DropdownMenuItem<int>(
                          value: score,
                          child: Text(
                            score.toString(),
                            style: TextStyle(
                              color: const Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        _updateScore(
                            playerIndex, roundIndex, holeIndex, value!);
                      },
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
