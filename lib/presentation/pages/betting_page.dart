import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:winbet_arena/presentation/blocs/bet/bet_bloc.dart';
import 'package:winbet_arena/presentation/blocs/bet/bet_event.dart';
import 'package:winbet_arena/presentation/blocs/bet/bet_state.dart';
import '../../../domain/entities/bet.dart';
import '../blocs/wallet/wallet_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/datasources/remote/wallet_remote_datasource.dart';

class BettingPage extends StatefulWidget {
  const BettingPage({super.key});

  @override
  State<BettingPage> createState() => _BettingPageState();
}

class _BettingPageState extends State<BettingPage> {
  double stake = 10;

  final String userId = "user123"; // Replace with actual user logic

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<WalletBloc>(
          create: (_) => WalletBloc(WalletRemoteDataSourceImpl(FirebaseFirestore.instance))..add(LoadWallet(userId)),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(title: Text("Place Bet (No-Loss)")),
        body: BlocConsumer<BetBloc, BetState>(
          listener: (context, state) {
            if (state is BetSuccess) {
              // On win, add credits to wallet
              BlocProvider.of<WalletBloc>(context).add(AddCredits(userId, stake));
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text("Bet placed successfully ✅ Credits added!")));
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
                  BlocBuilder<WalletBloc, WalletState>(
                    builder: (context, walletState) {
                      if (walletState is WalletLoading) {
                        return Text("Loading credits...");
                      }
                      if (walletState is WalletLoaded) {
                        return Text("Your Credits: ${walletState.wallet.credits}");
                      }
                      return Text("Your Credits: --");
                    },
                  ),
                  SizedBox(height: 10),
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
                        userId: userId,
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
      ),
    );
  }
}
