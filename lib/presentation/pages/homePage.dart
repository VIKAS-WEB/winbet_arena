import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../presentation/blocs/event/event_bloc.dart';
import 'package:winbet_arena/presentation/blocs/auth/auth_bloc.dart';
import 'package:winbet_arena/presentation/blocs/auth/auth_event.dart';
import '../blocs/team/team_bloc.dart';
import '../blocs/athlete/athlete_bloc.dart';
import 'betting_workflow_section.dart';
import '../../data/datasources/remote/team_remote_datasource.dart';
import '../../data/models/team_model.dart';
import 'package:winbet_arena/domain/entities/bet.dart';
import 'package:winbet_arena/domain/repositories/bet_repository.dart';
import 'package:winbet_arena/core/di/injection_container.dart' as di;
import '../../data/datasources/remote/athlete_remote_datasource.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:winbet_arena/presentation/pages/auth_pages/loginPage.dart';
import 'package:winbet_arena/main.dart';

// Team creation form with modern styling
class TeamCreateForm extends StatefulWidget {
  @override
  State<TeamCreateForm> createState() => _TeamCreateFormState();
}

class _TeamCreateFormState extends State<TeamCreateForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _logoController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _logoController.dispose();
    super.dispose();
  }

  void _createTeam() async {
    if (_formKey.currentState?.validate() ?? false) {
      final team = TeamModel(
        id: '', // Firestore will auto-generate
        name: _nameController.text,
        logoUrl: _logoController.text,
        followers: 0,
        trendingScore: 0,
        athleteIds: [],
      );
      final remote = TeamRemoteDataSourceImpl(FirebaseFirestore.instance);
      await remote.createTeam(team);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Team Created!', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.green.shade700,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      _nameController.clear();
      _logoController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create New Team',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Team Name',
                  labelStyle: TextStyle(color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.grey[850],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                  ),
                ),
                style: TextStyle(color: Colors.white),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Enter team name' : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _logoController,
                decoration: InputDecoration(
                  labelText: 'Logo URL',
                  labelStyle: TextStyle(color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.grey[850],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                  ),
                ),
                style: TextStyle(color: Colors.white),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Enter logo URL' : null,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _createTeam,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  elevation: 4,
                ),
                child: Text('Create Team', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    _HomeContent(),
    TeamsPage(),
    LiveStreamsPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<EventBloc>(create: (_) => EventBloc()..add(LoadEvents())),
        BlocProvider<TeamBloc>(create: (_) => TeamBloc(TeamRemoteDataSourceImpl(FirebaseFirestore.instance))..add(LoadTrendingTeams())),
        BlocProvider<AthleteBloc>(create: (_) => AthleteBloc(AthleteRemoteDataSourceImpl(FirebaseFirestore.instance))..add(LoadTrendingAthletes())),
      ],
      child: Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          title: Text("Sales Bets", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueAccent, Colors.purpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.logout, color: Colors.white),
              tooltip: 'Logout',
              onPressed: () async {
                final shouldLogout = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Logout'),
                    content: Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text('No'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text('Yes'),
                      ),
                    ],
                  ),
                );
                if (shouldLogout == true) {
                  BlocProvider.of<AuthBloc>(context).add(SignOutRequested());
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (route) => false,
                  );
                }
              },
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.blueAccent, Colors.purpleAccent]),
                ),
                child: Text('Navigation', style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Home'),
                onTap: () {
                  Navigator.pop(context);
                  _onItemTapped(0);
                },
              ),
              ListTile(
                leading: Icon(Icons.group),
                title: Text('Teams'),
                onTap: () {
                  Navigator.pop(context);
                  _onItemTapped(1);
                },
              ),
              ListTile(
                leading: Icon(Icons.live_tv),
                title: Text('Live Streams'),
                onTap: () {
                  Navigator.pop(context);
                  _onItemTapped(2);
                },
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Profile'),
                onTap: () {
                  Navigator.pop(context);
                  _onItemTapped(3);
                },
              ),
            ],
          ),
        ),
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
      ),
    );
  }
}

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;
  const BottomNavBar({required this.selectedIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      backgroundColor: Colors.grey[900],
      selectedItemColor: Colors.blueAccent,
      unselectedItemColor: Colors.grey[400],
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Teams'),
        BottomNavigationBarItem(icon: Icon(Icons.live_tv), label: 'Live'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}

// Main Home content (existing dashboard)
class _HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Text('Betting Workflow', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
          BettingWorkflowSection(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<EventBloc, EventState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<EventBloc>(context).add(
                          CreateEvent(
                            title: 'Business Challenge',
                            description: 'Achieve sales target Q3',
                            startTime: DateTime.now(),
                            endTime: DateTime.now().add(Duration(days: 7)),
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Event Created!', style: TextStyle(color: Colors.white)),
                            backgroundColor: Colors.green.shade700,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        elevation: 4,
                      ),
                      child: Text('Create Demo Event', style: TextStyle(fontSize: 16)),
                    );
                  },
                ),
                SizedBox(height: 16),
                TeamCreateForm(),
              ],
            ),
          ),
          // ...existing trending teams, athletes, bets, events sections...
        ],
      ),
    );
  }
}

// Placeholder Teams page
class TeamsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Teams', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
          SizedBox(height: 16),
          Expanded(
            child: BlocBuilder<TeamBloc, TeamState>(
              builder: (context, state) {
                if (state is TeamLoading) {
                  return Center(child: CircularProgressIndicator(color: Colors.blueAccent));
                }
                if (state is TeamLoaded) {
                  if (state.teams.isEmpty) {
                    return Center(child: Text('No teams found.', style: TextStyle(color: Colors.grey[400])));
                  }
                  return ListView.builder(
                    itemCount: state.teams.length,
                    itemBuilder: (context, index) {
                      final team = state.teams[index];
                      return Card(
                        color: Colors.grey[850],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: CircleAvatar(backgroundImage: NetworkImage(team.logoUrl), backgroundColor: Colors.grey[700]),
                          title: Text(team.name, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          subtitle: Text('Followers: ${team.followers}', style: TextStyle(color: Colors.grey[400])),
                        ),
                      );
                    },
                  );
                }
                if (state is TeamError) {
                  return Center(child: Text('Error: ${state.message}', style: TextStyle(color: Colors.redAccent)));
                }
                return Center(child: Text('No teams found.', style: TextStyle(color: Colors.grey[400])));
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Placeholder Live Streams page
class LiveStreamsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Live Streams', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
          SizedBox(height: 16),
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: Colors.grey[850],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text('Live streaming will appear here', style: TextStyle(color: Colors.grey[400], fontSize: 18)),
            ),
          ),
          SizedBox(height: 24),
          Text('Bet List', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          SizedBox(height: 12),
          Expanded(
            child: StreamBuilder<List<Bet>>(
              stream: di.sl<BetRepository>().getUserBets("user123"),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator(color: Colors.blueAccent));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No bets placed yet.', style: TextStyle(color: Colors.grey[400])));
                }
                final bets = snapshot.data!;
                return ListView.builder(
                  itemCount: bets.length,
                  itemBuilder: (context, index) {
                    final bet = bets[index];
                    return Card(
                      color: Colors.grey[850],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text('Team: ${bet.teamId}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        subtitle: Text('Stake: ${bet.stake} | Status: ${bet.status}', style: TextStyle(color: Colors.grey[400])),
                        trailing: Text('Bet ID: ${bet.id}', style: TextStyle(color: Colors.blueAccent)),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Placeholder Profile page
class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ThemeMode get currentMode => SalesBetsApp.themeModeNotifier.value;

  @override
  Widget build(BuildContext context) {
    // Replace with actual user data from your auth system
    final userName = "User Name";
    final userEmail = "user@email.com";
    final userPhoto = null; // Replace with actual photo URL if available
    final appVersion = "1.0.0";

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 32),
          CircleAvatar(
            radius: 48,
            backgroundImage: userPhoto != null ? NetworkImage(userPhoto) : null,
            child: userPhoto == null ? Icon(Icons.person, size: 48, color: Colors.white) : null,
            backgroundColor: Colors.blueAccent,
          ),
          SizedBox(height: 16),
          Text(userName, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
          SizedBox(height: 8),
          Text(userEmail, style: TextStyle(fontSize: 16, color: Colors.grey[400])),
          SizedBox(height: 32),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.redAccent),
            title: Text('Logout', style: TextStyle(color: Colors.white)),
            onTap: () async {
              final shouldLogout = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Logout'),
                  content: Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text('No'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text('Yes'),
                    ),
                  ],
                ),
              );
              if (shouldLogout == true) {
                BlocProvider.of<AuthBloc>(context).add(SignOutRequested());
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (route) => false,
                );
              }
            },
          ),
          Divider(color: Colors.grey[700]),
          ListTile(
            leading: Icon(Icons.info_outline, color: Colors.blueAccent),
            title: Text('App Version', style: TextStyle(color: Colors.white)),
            trailing: Text(appVersion, style: TextStyle(color: Colors.grey[400])),
          ),
          Divider(color: Colors.grey[700]),
          SwitchListTile(
            title: Text('Dark Mode', style: TextStyle(color: Colors.white)),
            secondary: Icon(currentMode == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode, color: Colors.blueAccent),
            value: currentMode == ThemeMode.dark,
            onChanged: (val) {
              setState(() {
                SalesBetsApp.themeModeNotifier.value = val ? ThemeMode.dark : ThemeMode.light;
              });
            },
          ),
        ],
      ),
    );
  }
}
