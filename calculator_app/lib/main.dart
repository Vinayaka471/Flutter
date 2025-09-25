import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Google Mobile Ads SDK
  await MobileAds.instance.initialize();
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Calculator",
      theme: ThemeData(primarySwatch: Colors.red),
      home: const CalculatorHome(),
    );
  }
}

// ============================== Calculator Home Screen ==============================

class CalculatorHome extends StatefulWidget {
  const CalculatorHome({super.key});

  @override
  State<CalculatorHome> createState() => _CalculatorHomeState();
}

class _CalculatorHomeState extends State<CalculatorHome> {
  String display = "0";
  String operand = "";
  double num1 = 0;
  double num2 = 0;

  int coins = 0; // 💰 Coins system
  bool achievementUnlocked = false; // Achievement flag

  // ---------------- Ad Variables ----------------
  BannerAd? _bannerAd;
  bool _isBannerAdReady = false;

  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;

  @override
  void initState() {
    super.initState();
    _loadCoins(); // load saved coins
    _loadBannerAd();
    _loadInterstitialAd();
    _loadRewardedAd();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
    super.dispose();
  }

  // ---------------- Coins Persistence ----------------
  Future<void> _loadCoins() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      coins = prefs.getInt('coins') ?? 0;
      achievementUnlocked = coins >= 50;
    });
  }

  Future<void> _saveCoins() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('coins', coins);

    // Check for achievement
    if (coins >= 50 && !achievementUnlocked) {
      setState(() {
        achievementUnlocked = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("🏆 Achievement Unlocked! You collected 50 coins!"),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  // ---------------- Banner Ad ----------------
  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111', // Test Banner Ad
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print('Banner failed: $error');
        },
      ),
    )..load();
  }

  // ---------------- Interstitial Ad ----------------
  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId:
          'ca-app-pub-3940256099942544/1033173712', // Test Interstitial Ad
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (error) {
          print('Interstitial failed: $error');
        },
      ),
    );
  }

  void _showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.show();
      _interstitialAd = null;
      _loadInterstitialAd(); // preload next interstitial
    }
  }

  // ---------------- Rewarded Ad ----------------
  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/5224354917', // Test Rewarded Ad
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
        },
        onAdFailedToLoad: (error) {
          print('Rewarded failed: $error');
        },
      ),
    );
  }

  void _showRewardedAd() {
    if (_rewardedAd != null) {
      _rewardedAd!.show(
        onUserEarnedReward: (ad, reward) {
          setState(() {
            coins += reward.amount.toInt(); // add reward coins
          });
          _saveCoins(); // save coins permanently
        },
      );
      _rewardedAd = null;
      _loadRewardedAd(); // preload next rewarded ad
    }
  }

  // ---------------- Calculator Logic ----------------
  void buttonPressed(String text) {
    setState(() {
      if (text == "C") {
        display = "0";
        num1 = 0;
        num2 = 0;
        operand = "";
      } else if (text == "+" || text == "-" || text == "*" || text == "/") {
        num1 = double.parse(display);
        operand = text;
        display = "0";
      } else if (text == "=") {
        _showInterstitialAd(); // show ad on calculation
        num2 = double.parse(display);
        if (operand == "+") {
          display = (num1 + num2).toString();
        } else if (operand == "-") {
          display = (num1 - num2).toString();
        } else if (operand == "*") {
          display = (num1 * num2).toString();
        } else if (operand == "/") {
          display = num2 != 0 ? (num1 / num2).toString() : "Error";
        }
        operand = "";
      } else if (text == "Reward AD") {
        _showRewardedAd(); // show rewarded ad
      } else {
        if (display == "0") {
          display = text;
        } else {
          display += text;
        }
      }
    });
  }

  // ---------------- Build Calculator Buttons ----------------
  Widget buildButton(String text, Color color) {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(20),
          backgroundColor: color,
        ),
        onPressed: () => buttonPressed(text),
        child: Text(text, style: const TextStyle(fontSize: 24)),
      ),
    );
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calculator"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Center(
              child: Text(
                "Coins: ${coins.toInt()}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(24),
              child: Text(
                display,
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Row(
            children: [
              buildButton("7", Colors.grey),
              buildButton("8", Colors.grey),
              buildButton("9", Colors.grey),
              buildButton("/", Colors.orange),
            ],
          ),
          Row(
            children: [
              buildButton("4", Colors.grey),
              buildButton("5", Colors.grey),
              buildButton("6", Colors.grey),
              buildButton("*", Colors.orange),
            ],
          ),
          Row(
            children: [
              buildButton("1", Colors.grey),
              buildButton("2", Colors.grey),
              buildButton("3", Colors.grey),
              buildButton("-", Colors.orange),
            ],
          ),
          Row(
            children: [
              buildButton("C", Colors.grey),
              buildButton("0", Colors.grey),
              buildButton("=", Colors.grey),
              buildButton("+", Colors.orange),
            ],
          ),
          Row(
            children: [
              buildButton(
                "Reward AD",
                _rewardedAd != null ? Colors.green : Colors.grey,
              ), // button for Rewarded Ad
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(20),
                    backgroundColor: achievementUnlocked
                        ? Colors.purple
                        : Colors.grey,
                  ),
                  onPressed: achievementUnlocked
                      ? () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "🎉 Achievement: Premium unlocked!",
                              ),
                            ),
                          );
                        }
                      : null,
                  child: Text(
                    achievementUnlocked ? "Premium Achieved!" : "Premium",
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: _isBannerAdReady
          ? SizedBox(
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            )
          : null,
    );
  }
}
