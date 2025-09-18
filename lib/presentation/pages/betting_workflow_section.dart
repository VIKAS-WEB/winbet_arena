import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/team/team_bloc.dart';
import '../../domain/entities/bet.dart';
import '../blocs/bet/bet_bloc.dart';
import '../blocs/bet/bet_event.dart';
import '../blocs/bet/bet_state.dart';

class BettingWorkflowSection extends StatefulWidget {
  @override
  State<BettingWorkflowSection> createState() => _BettingWorkflowSectionState();
}

class _BettingWorkflowSectionState extends State<BettingWorkflowSection> with SingleTickerProviderStateMixin {
  double stake = 10;
  String? selectedTeamId;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeamBloc, TeamState>(
      builder: (context, teamState) {
        final teams = teamState is TeamLoaded ? teamState.teams : [];
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Choose a Team:', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                teams.isEmpty
                    ? Text('No teams available.')
                    : DropdownButton<String>(
                        value: selectedTeamId,
                        hint: Text('Select Team'),
                        items: teams.map<DropdownMenuItem<String>>((team) => DropdownMenuItem<String>(
                          value: team.id,
                          child: Text(team.name),
                        )).toList(),
                        onChanged: (id) => setState(() => selectedTeamId = id),
                      ),
                SizedBox(height: 16),
                Text('Stake Credits: ${stake.toInt()}'),
                Slider(
                  min: 10,
                  max: 1000,
                  divisions: 100,
                  value: stake,
                  onChanged: (v) => setState(() => stake = v),
                ),
                SizedBox(height: 16),
                BlocConsumer<BetBloc, BetState>(
                  listener: (context, state) {
                    if (state is BetSuccess) {
                      _controller.forward(from: 0);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('You Win! Credits Added!')),
                      );
                    }
                  },
                  builder: (context, state) {
                    return Column(
                      children: [
                        ElevatedButton(
                          onPressed: selectedTeamId == null || state is BetLoading
                              ? null
                              : () {
                                  final bet = Bet(
                                    id: DateTime.now().toString(),
                                    userId: "user123", // Replace with actual user
                                    teamId: selectedTeamId!,
                                    stake: stake,
                                    status: "pending",
                                  );
                                  context.read<BetBloc>().add(PlaceBetEvent(bet));
                                },
                          child: Text('Place Bet'),
                        ),
                        if (selectedTeamId == null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              'Select a team to enable betting.',
                              style: TextStyle(color: Colors.orange, fontSize: 13),
                            ),
                          ),
                        if (state is BetLoading) CircularProgressIndicator(),
                        if (state is BetSuccess)
                          ScaleTransition(
                            scale: _animation,
                            child: Icon(Icons.emoji_events, color: Colors.amber, size: 48),
                          ),
                        if (state is BetError)
                          Text('Error: ${state.message}', style: TextStyle(color: Colors.red)),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
