import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(const BooCloneApp());
}

class BooCloneApp extends StatelessWidget {
  const BooCloneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: const Color(0xFF0D0B14)),
      home: const SoulScrollPage(),
    );
  }
}

class SoulScrollPage extends StatefulWidget {
  const SoulScrollPage({super.key});

  @override
  State<SoulScrollPage> createState() => _SoulScrollPageState();
}

class _SoulScrollPageState extends State<SoulScrollPage> {
  final PageController _pageController = PageController();
  bool isMatched = false;
  int matchedIndex = 0;
  double matchScore = 0.0;

  final List<Map<String, dynamic>> profiles = [
    {
      'name': 'Marcellina',
      'age': '22',
      'job': 'Adm',
      'location': 'VILLA PERMATA HIJAU, West Java 🇮🇩',
      'mbti': 'INTP',
      'zodiac': 'Aquarius',
      'image': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=800',
    },
    {
      'name': 'Sarah',
      'age': '24',
      'job': 'Designer',
      'location': 'Jakarta, Indonesia 🇮🇩',
      'mbti': 'ENFP',
      'zodiac': 'Leo',
      'image': 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=800',
    },
    {
      'name': 'Jessica',
      'age': '21',
      'job': 'Student',
      'location': 'Bandung, West Java 🇮🇩',
      'mbti': 'INFJ',
      'zodiac': 'Gemini',
      'image': 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=800',
    },
  ];

  void _goToNextCard() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
    );
  }

  void _onDislikePressed() {
    HapticFeedback.lightImpact();
    _goToNextCard();
  }

  void _onLikePressed() {
    HapticFeedback.heavyImpact();
    setState(() {
      matchedIndex = _pageController.page?.round() ?? 0;
      matchScore = 75 + Random().nextInt(23).toDouble();
      isMatched = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _buildBooHeader(),
                _buildToggleTabs(),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    scrollDirection: Axis.vertical,
                    itemCount: profiles.length,
                    itemBuilder: (context, index) {
                      return ProfileCard(data: profiles[index]);
                    },
                  ),
                ),
              ],
            ),
            Positioned(bottom: 30, left: 0, right: 0, child: _buildActionButtons()),
            if (isMatched) _buildMatchOverlay(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBooHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.menu, color: Colors.white, size: 28),
              const SizedBox(width: 20),
              const Icon(Icons.bolt_rounded, color: Colors.amber, size: 28),
            ],
          ),
          const Text(
            'BOO',
            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 2.0),
          ),
          Row(
            children: [
              const Icon(Icons.translate_rounded, color: Colors.white, size: 24),
              const SizedBox(width: 20),
              const Icon(Icons.tune_rounded, color: Colors.white, size: 24),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToggleTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [_pillTab("NEW SOULS", true), const SizedBox(width: 20), _pillTab("DISCOVERY", false)]),
    );
  }

  Widget _pillTab(String label, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(color: active ? const Color(0xFF3BB2B8) : Colors.transparent, borderRadius: BorderRadius.circular(20)),
      child: Text(
        label,
        style: TextStyle(color: active ? Colors.black : Colors.grey, fontWeight: FontWeight.bold, fontSize: 11),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _circleBtn(Icons.rocket_launch, Colors.teal, 45, () {}),
        _circleBtn(Icons.close, Colors.red, 55, _onDislikePressed),
        _circleBtn(Icons.favorite, Colors.pink, 45, () {}),
        _circleBtn(Icons.favorite, const Color(0xFF3BB2B8), 55, _onLikePressed),
        _circleBtn(Icons.send, Colors.teal, 45, () {}),
      ],
    );
  }

  Widget _circleBtn(IconData icon, Color color, double size, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withValues(alpha: 0.4),
          border: Border.all(color: Colors.white.withValues(alpha: 0.6), width: 1.5),
        ),
        child: Icon(icon, color: color, size: size * 0.45),
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      backgroundColor: Colors.black,
      currentIndex: 0,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF3BB2B8),
      unselectedItemColor: Colors.grey,
      selectedFontSize: 10,
      unselectedFontSize: 10,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Match'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline, size: 28), label: 'Create'),
        BottomNavigationBarItem(icon: Icon(Icons.public), label: 'Universes'),
        BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Messages'),
      ],
    );
  }

  Widget _buildMatchOverlay() {
    return Container(
      color: Colors.black.withValues(alpha: 0.95),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "IT'S A MATCH!",
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF3BB2B8), letterSpacing: 2),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [_matchAvatar("https://i.pravatar.cc/150?u=me"), _compatibilityRing(matchScore), _matchAvatar(profiles[matchedIndex]['image'])],
          ),
          const SizedBox(height: 60),
          ElevatedButton(
            onPressed: () {
              setState(() => isMatched = false);
              _goToNextCard();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3BB2B8),
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 18),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            child: const Text("SAY HELLO", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          TextButton(
            onPressed: () => setState(() => isMatched = false),
            child: const Text("Keep Browsing", style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  Widget _matchAvatar(String url) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF3BB2B8), width: 2),
      ),
      child: CircleAvatar(radius: 50, backgroundImage: NetworkImage(url)),
    );
  }

  Widget _compatibilityRing(double score) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          CircularProgressIndicator(value: score / 100, color: const Color(0xFF3BB2B8), strokeWidth: 6),
          const SizedBox(height: 8),
          Text("${score.toInt()}%", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ],
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const ProfileCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 100),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        image: DecorationImage(image: NetworkImage(data['image']), fit: BoxFit.cover),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.black12, Colors.black.withValues(alpha: 0.8)]),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [_statusBadge("ONLINE", const Color(0xFF3BB2B8)), _statusBadge("NEW SOUL", const Color(0xFF3BB2B8))],
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Text(data['name'], style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                const Icon(Icons.check_circle, color: Color(0xFF3BB2B8), size: 24),
              ],
            ),
            Text("💼 ${data['job']}", style: const TextStyle(color: Colors.white70)),
            Text("📍 ${data['location']}", style: const TextStyle(color: Colors.white70, fontSize: 11)),
            const SizedBox(height: 15),
            Row(
              children: [
                _traitBadge(data['age'], Colors.pink.shade300),
                _traitBadge(data['mbti'], Colors.orange.shade400),
                _traitBadge(data['zodiac'], const Color(0xFF3BB2B8)),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _statusBadge(String label, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold)),
    );
  }

  Widget _traitBadge(String label, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }
}
