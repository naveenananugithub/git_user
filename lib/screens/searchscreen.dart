// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/user_provider.dart';

class GithubSearchPage extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  final String _token = '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';

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GitHubProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'GitHub User Search',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black, Colors.blueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {},
              child: Image.asset(
                'images/git.png',
                width: 30,
                height: 30,
                color: Colors.white,
              ),
            ),
          ),
        ],
        elevation: 5.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            _buildSearchField(provider, context),
            const SizedBox(height: 20),
            _buildContent(provider),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField(GitHubProvider provider, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey),
      ),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: 'Enter GitHub username/organization',
          border: InputBorder.none,
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_controller.text.isNotEmpty)
                IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _controller.clear();
                    provider.clearUsers();
                    FocusScope.of(context).unfocus();
                  },
                ),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  if (_controller.text.isNotEmpty) {
                    provider.searchUsers(_controller.text, token: _token);
                    FocusScope.of(context).unfocus();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(GitHubProvider provider) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (provider.hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 50),
            const SizedBox(height: 10),
            Text(
              'Network Error',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Please check your connection and try again.',
              style: TextStyle(fontSize: 16, color: Colors.red[200]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    } else if (provider.users.isEmpty && _controller.text.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_search, color: Colors.blueAccent, size: 50),
            const SizedBox(height: 10),
            Text(
              'No users found.',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Try a different username or check the spelling.',
              style: TextStyle(fontSize: 16, color: Colors.blue[200]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    } else if (provider.users.isEmpty && _controller.text.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, color: Colors.grey, size: 50),
            const SizedBox(height: 10),
            Text(
              'Please search.',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Enter a GitHub username to begin your search.',
              style: TextStyle(fontSize: 16, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    } else {
      return Expanded(
        child: ListView.separated(
          itemCount: provider.users.length,
          separatorBuilder: (context, index) =>
              Divider(height: 1, color: Colors.grey[300]),
          itemBuilder: (context, index) {
            final user = provider.users[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(user.avatarUrl),
                radius: 25,
              ),
              title: Text(
                user.login,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 81, 132, 221)
                        .withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.blueAccent),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Repositories: ${user.publicRepos}',
                      style: const TextStyle(
                        color: Colors.deepPurpleAccent,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              onTap: () {},
            );
          },
        ),
      );
    }
  }
}
