import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

class DiscoverScreen extends StatefulWidget {
  @override
  _DiscoverScreenState createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  List animeList = [];
  List suggestions = [];
  bool isLoading = false;
  bool isSearching = false;
  Timer? _debounce;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchAnime();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    final query = _searchController.text.trim();

    if (query.length < 3) {
      setState(() {
        suggestions = [];
      });
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 500), () {
      fetchSuggestions(query);
    });
  }

  Future<void> fetchSuggestions(String query) async {
    try {
      final url = Uri.parse("https://api.jikan.moe/v4/anime?q=$query&limit=5");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          suggestions = json.decode(response.body)['data'];
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load suggestions");
      }
    } catch (e) {
      print("Error fetching suggestions: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchAnime() async {
    final url = Uri.parse("https://api.jikan.moe/v4/anime?limit=5");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        animeList = json.decode(response.body)['data'].take(6).toList();
      });
    } else {
      throw Exception("Failed to load anime");
    }
  }

  void performSearch(String query) {
    if (query.isEmpty) return;
    setState(() {
      isSearching = true;
      suggestions = [];
    });
    searchAnime(query);
  }

  Future<void> searchAnime(String anime) async {
    setState(() {
      isLoading = true;
    });
    try {
      final url = Uri.parse("https://api.jikan.moe/v4/anime?q=$anime");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          animeList = json.decode(response.body)['data'];
          isLoading = false;
          isSearching = false;
        });
      } else {
        throw Exception("Failed to load anime");
      }
    } catch (e) {
      print("Error fetching anime: $e");
      setState(() {
        isLoading = false;
        isSearching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Search.",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search anime...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon:
                    _searchController.text.isNotEmpty
                        ? IconButton(
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              suggestions = [];
                            });
                          },
                          icon: Icon(Icons.clear),
                        )
                        : null,
              ),
              onSubmitted: (value) => performSearch(value),
            ),
            if (suggestions.isNotEmpty && !isSearching)
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                margin: EdgeInsets.only(top: 5),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: suggestions.length,
                  itemBuilder: (context, index) {
                    final anime = suggestions[index];
                    return ListTile(
                      leading:
                          anime['images']?['jpg']?['small_image_url'] != null
                              ? ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Image.network(
                                  anime['images']['jpg']['small_image_url'],
                                  width: 40,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (_, __, ___) => Container(
                                        width: 40,
                                        height: 60,
                                        color: Colors.grey.shade300,
                                        child: Icon(
                                          Icons.image,
                                          color: Colors.grey.shade800,
                                        ),
                                      ),
                                ),
                              )
                              : SizedBox(width: 40),
                      title: Text(
                        anime['title'] ?? 'Unknown',
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        anime['year'] != null
                            ? 'Year: ${anime['year']}'
                            : anime['status'] ?? '',
                        style: TextStyle(fontSize: 12),
                      ),
                      onTap: () {
                        _searchController.text = anime['title'];
                        performSearch(anime['title']);
                        FocusScope.of(context).unfocus();
                      },
                    );
                  },
                ),
              ),
            const SizedBox(height: 20),
            if (isLoading) Center(child: CircularProgressIndicator()),

            if (!isLoading) ...[
              Text(
                isSearching
                    ? "Search Results for '${_searchController.text}'"
                    : "Popular Anime",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: animeList.length,
                itemBuilder: (context, index) {
                  final anime = animeList[index];

                  return GestureDetector(
                    onTap: () {
                      context.go('/anime/${anime['id']}');
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              anime['images']['jpg']['large_image_url'],
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder:
                                  (_, __, ___) => Container(
                                    color: Colors.grey.shade300,
                                    child: Center(
                                      child: Icon(
                                        Icons.image,
                                        color: Colors.grey.shade800,
                                      ),
                                    ),
                                  ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          anime['title'] ?? 'Unknown',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        Text(
                          anime['type'] ?? '',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
