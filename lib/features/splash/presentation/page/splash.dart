import 'package:day_tick/core/utils/app_colours.dart';
import 'package:day_tick/features/home/presentation/page/home.dart';
import 'package:day_tick/features/profile/presentation/page/login.dart';
import 'package:day_tick/features/splash/presentation/bloc/splash_bloc.dart';
import 'package:day_tick/features/splash/presentation/bloc/splash_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with TickerProviderStateMixin {
  late AnimationController pulseController;
  late AnimationController fadeController;
  late Animation<double> pulseAnimation;
  late Animation<double> fadeAnimation;

  @override
  void initState() {
    super.initState();
    context.read<SplashBloc>().add(StartSplash());

    pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..forward();

    pulseAnimation = Tween<double>(begin: .9, end: 1.08).animate(
      CurvedAnimation(parent: pulseController, curve: Curves.easeInOut),
    );

    fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: fadeController, curve: Curves.easeIn));
  }

  @override
  void dispose() {
    pulseController.dispose();
    fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocListener<SplashBloc, SplashState>(
      listener: (context, state) {
      
            if (state is SplashGoHome) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const Home()),
              );
            }

            if (state is SplashGoLogin) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            }
          },
        
      
      child: Scaffold(
        backgroundColor: kbgcolor,
        body: Container(
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(gradient: kBackgroundGradient),
          child: FadeTransition(
            opacity: fadeAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: pulseAnimation,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 180,
                        width: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: kgreencolor.withOpacity(.08),
                          boxShadow: [
                            BoxShadow(
                              color: kgreencolor.withOpacity(.25),
                              blurRadius: 50,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 110,
                        width: 110,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xff11192e),
                          border: Border.all(
                            color: kgreencolor.withOpacity(.5),
                            width: 1.5,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(22),
                          child: Image.asset('assets/images/love.png'),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 35),

                Text(
                  'DAY TICK',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Build Better Days',
                  style: TextStyle(
                    color: Colors.white.withOpacity(.45),
                    fontSize: 14,
                    letterSpacing: 1.2,
                  ),
                ),

                const SizedBox(height: 45),

                SizedBox(
                  width: 70,
                  child: LinearProgressIndicator(
                    minHeight: 3,
                    backgroundColor: Colors.white10,
                    valueColor: AlwaysStoppedAnimation(kgreencolor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
