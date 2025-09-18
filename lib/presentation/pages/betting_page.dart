import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:winbet_arena/presentation/blocs/bet/bet_bloc.dart';
import 'package:winbet_arena/presentation/blocs/bet/bet_event.dart';
import 'package:winbet_arena/presentation/blocs/bet/bet_state.dart';
import '../../../domain/entities/bet.dart';

class BettingPage extends StatefulWidget {
  const BettingPage({super.key});

  @override
  State<BettingPage> createState() => _BettingPageState();
}

class _BettingPageState extends State<BettingPage> {
  double stake = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Place Bet (No-Loss)")),
      body: BlocConsumer<BetBloc, BetState>(
        listener: (context, state) {
          if (state is BetSuccess) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("Bet placed successfully ✅")));
          }
          if (state is BetError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("Error: ${state.message}")));
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text("Stake Credits (only gain, never lose): $stake"),
                Slider(
                  min: 10,
                  max: 1000,
                  divisions: 100,
                  value: stake,
                  onChanged: (v) => setState(() => stake = v),
                ),
                SizedBox(height: 20),
                if (state is BetLoading) CircularProgressIndicator(),
                ElevatedButton(
                  onPressed: () {
                    final bet = Bet(
                      id: DateTime.now().toString(),
                      userId: "user123",
                      teamId: "team1",
                      stake: stake,
                      status: "pending",
                    );
                    context.read<BetBloc>().add(PlaceBetEvent(bet));
                  },
                  child: Text("Place Bet"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
