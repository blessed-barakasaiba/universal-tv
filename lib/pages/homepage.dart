import 'package:blessed_tv/pages/videopage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<Map<String, String>> channels = [];

  @override
  void initState() {
    super.initState();
    fetchChannels();
  }

  Future<void> fetchChannels() async {
    final url = Uri.parse('https://iptv-org.github.io/iptv/index.m3u');
    final response = await http.get(url);
    print(response);

    if (response.statusCode == 200) {
      final lines = response.body.split('\n');
      String? currentName;

      for (String line in lines) {
        final trimmed = line.trim();
        if (line.trim().startsWith('#EXTINF')) {
          final nameMatch = RegExp(r'#EXTINF[^,]*,(.+)').firstMatch(trimmed);
          currentName = nameMatch?.group(1)?.trim() ?? "Unknown channel";
        } else if (line.startsWith('http') && currentName != null) {
          channels.add({'name': currentName, 'url': line.trim()});
          currentName = null;
        }
      }
      setState(() {});
    } else {
      print("Failed to fetch channels: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Blessed tv", style: TextStyle(color: Colors.white)),
      ),
      body: channels.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: channels.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(channels[index]['name'] ?? 'Unknown'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Videopage(
                          channelName: channels[index]['name']!,
                          videoUrl: channels[index]['url']!,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
