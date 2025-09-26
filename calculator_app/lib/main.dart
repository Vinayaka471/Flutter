import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Kannada Calculator",
      theme: ThemeData(primarySwatch: Colors.red),
      home: const CalculatorHome(),
    );
  }
}

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

  int coins = 0;
  bool achievementUnlocked = false;

  // ---------------- Ad Variables ----------------
  BannerAd? _bannerAd;
  bool _isBannerAdReady = false;

  RewardedAd? _rewardedAd;

  // ---------------- Cooldown ----------------
  bool isCooldown = false;
  int cooldownTime = 0;

  @override
  void initState() {
    super.initState();
    _loadCoins();
    _loadBannerAd();
    _loadRewardedAd();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _rewardedAd?.dispose();
    super.dispose();
  }

  // ---------------- Coins ----------------
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
      adUnitId: 'ca-app-pub-3940256099942544/6300978111',
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

  // ---------------- Rewarded Ad ----------------
  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/5224354917',
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
            coins += reward.amount.toInt();
          });
          _saveCoins();
        },
      );
      _rewardedAd = null;
      _loadRewardedAd();
    }
  }

  // ---------------- Calculator Logic ----------------
  void buttonPressed(String text) {
    if (isCooldown) return; // block during cooldown

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
        // Start cooldown
        isCooldown = true;
        cooldownTime = 30;
        Timer.periodic(const Duration(seconds: 1), (timer) {
          setState(() {
            cooldownTime--;
          });
          if (cooldownTime <= 0) {
            setState(() {
              isCooldown = false;
            });
            timer.cancel();
          }
        });

        num2 = double.parse(display);
        if (operand == "+") display = (num1 + num2).toString();
        if (operand == "-") display = (num1 - num2).toString();
        if (operand == "*") display = (num1 * num2).toString();
        if (operand == "/")
          display = num2 != 0 ? (num1 / num2).toString() : "Error";
        operand = "";
      } else if (text == "Reward AD") {
        _showRewardedAd();
      } else {
        if (display == "0") {
          display = text;
        } else {
          display += text;
        }
      }
    });
  }

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
        title: const Text("Kannada Calculator"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Center(
              child: isCooldown
                  ? Text(
                      "Cooldown: $cooldownTime s",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : Text(
                      "Coins: $coins",
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
              buildButton("Reward AD", Colors.green),
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
