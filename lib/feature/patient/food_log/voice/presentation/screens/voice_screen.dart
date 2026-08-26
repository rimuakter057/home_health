import 'package:ezygut/share/widgets/card/app_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:ezygut/feature/patient/food_log/controller/food_log_controller.dart';
import 'package:ezygut/utils/color/app_colors.dart';
import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';

class VoiceScreen extends StatefulWidget {
  const VoiceScreen({super.key});

  @override
  State<VoiceScreen> createState() => _VoiceScreenState();
}

class _VoiceScreenState extends State<VoiceScreen> {
  final FoodLogController controller = Get.find<FoodLogController>();
  final stt.SpeechToText _speech = stt.SpeechToText();
  final TextEditingController _manualController = TextEditingController();

  bool _speechInitialized = false;
  bool isListening = false;
  bool _permissionDenied = false;  // ✅ permission deny track
  bool _showManualEdit = false;    // ✅ manual edit fallback
  String text = "Tap the microphone and tell me what you ate...";
  double soundLevel = 0.0;

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    final micStatus = await Permission.microphone.request();

    if (micStatus.isPermanentlyDenied || !micStatus.isGranted) {
      // ✅ Denied → settings button দেখাবে
      setState(() {
        _permissionDenied = true;
        text = "Microphone permission denied.";
      });
      return;
    }

    try {
      _speechInitialized = await _speech.initialize(
        onError: (error) => setState(() => isListening = false),
        onStatus: (status) {
          if (!mounted) return;
          if (status == 'done' || status == 'notListening') {
            if (text == "Listening...") {
              _stopListening(noSpeech: true);
            } else {
              _stopListening();
            }
          }
        },
      );
    } catch (e) {
      debugPrint("Speech Init Error: $e");
    }
    setState(() {});
  }

  void _listen() async {
    if (!_speechInitialized) {
      setState(() => text = "Speech recognition not available.");
      return;
    }

    if (!isListening) {
      setState(() {
        isListening = true;
        _showManualEdit = false;
        text = "Listening...";
      });

      _speech.listen(
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 5),
        onResult: (result) {
          if (result.recognizedWords.isNotEmpty) {
            setState(() => text = result.recognizedWords);
          }

          if (result.finalResult) {
            if (result.recognizedWords.isNotEmpty) {
              _stopListening();
              controller.sendText(text: result.recognizedWords, context: context);
            } else {
              _stopListening(noSpeech: true);
            }
          }
        },
        onSoundLevelChange: (level) =>
            setState(() => soundLevel = level.clamp(0.0, 10.0)),
      );
    } else {
      // ✅ User manually tap করে stop করলে যা recognize হয়েছে সেটা পাঠাবে
      final recognized = text;
      _stopListening();
      if (recognized.isNotEmpty &&
          recognized != "Listening..." &&
          recognized != "Nothing heard. Please try again.") {
        controller.sendText(text: recognized, context: context);
      }
    }
  }

  void _stopListening({bool noSpeech = false}) {
    _speech.stop();
    if (!mounted) return;
    setState(() {
      isListening = false;
      soundLevel = 0.0;
      if (noSpeech || text == "Listening...") {
        text = "Nothing heard. Please try again.";
        // ✅ Manual edit fallback দেখাবে
        _showManualEdit = true;
        _manualController.clear();
      }
    });
  }

  void _submitManualText() {
    final typed = _manualController.text.trim();
    if (typed.isNotEmpty) {
      controller.sendText(text: typed, context: context);
      setState(() => _showManualEdit = false);
    }
  }

  @override
  void dispose() {
    _speech.stop();
    _manualController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryColor,
              AppColors.primaryColor.withAlpha(200),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // --- Top Bar ---
              Padding(
                padding: ResponsiveHelper.symmetric(horizontal: 16, vertical: 10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                            size: ResponsiveHelper.iconSize(28),
                          ),
                          onPressed: () => context.pop(),
                        ),
                        const Spacer(),
                        Text(
                          "VOICE LOG",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: ResponsiveHelper.fontSize(14),
                            letterSpacing: 2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        SizedBox(width: ResponsiveHelper.spacing(48)),
                      ],
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(10)),
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Example:",
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: ResponsiveHelper.fontSize(10),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: ResponsiveHelper.spacing(4)),
                          Text(
                            "Grilled salmon 200g with steamed broccoli 100g for dinner.",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: ResponsiveHelper.fontSize(13),
                              fontStyle: FontStyle.italic,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // ✅ Permission Denied UI — Settings button দেখাবে
              if (_permissionDenied) ...[
                Icon(
                  Icons.mic_off,
                  color: Colors.white54,
                  size: ResponsiveHelper.iconSize(52),
                ),
                SizedBox(height: ResponsiveHelper.spacing(16)),
                Padding(
                  padding: ResponsiveHelper.symmetric(horizontal: 32),
                  child: Text(
                    "Microphone access is required\nto use voice logging.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: ResponsiveHelper.fontSize(15),
                      height: 1.5,
                    ),
                  ),
                ),
                SizedBox(height: ResponsiveHelper.spacing(24)),
                ElevatedButton.icon(
                  // ✅ Device settings এ যাবে
                  onPressed: () => openAppSettings(),
                  icon: const Icon(Icons.settings, color: AppColors.primaryColor),
                  label: Text(
                    "Open Settings",
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: ResponsiveHelper.fontSize(14),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: ResponsiveHelper.symmetric(horizontal: 28, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        ResponsiveHelper.borderRadius(12),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
              ] else ...[
                // --- Animated Visualizer ---
                SizedBox(
                  height: ResponsiveHelper.height(100),
                  child: Center(
                    child: isListening
                        ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        5,
                            (index) => _buildAnimatedBar(index),
                      ),
                    )
                        : Icon(
                      Icons.graphic_eq,
                      color: Colors.white.withOpacity(0.2),
                      size: ResponsiveHelper.iconSize(40),
                    ),
                  ),
                ),

                const Spacer(),

                // --- Transcription Text ---
                Padding(
                  padding: ResponsiveHelper.symmetric(horizontal: 40),
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isListening ? Colors.white : Colors.white70,
                      fontSize: ResponsiveHelper.fontSize(22),
                      height: 1.4,
                      fontWeight:
                      isListening ? FontWeight.w600 : FontWeight.w300,
                    ),
                  ),
                ),

                // ✅ Manual edit fallback — "Nothing heard" এর পরে দেখাবে
                if (_showManualEdit) ...[
                  SizedBox(height: ResponsiveHelper.spacing(16)),
                  Padding(
                    padding: ResponsiveHelper.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        TextField(
                          controller: _manualController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "Type your meal instead...",
                            hintStyle:
                            const TextStyle(color: Colors.white54),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                ResponsiveHelper.borderRadius(10),
                              ),
                              borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.3),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                ResponsiveHelper.borderRadius(10),
                              ),
                              borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.3),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                ResponsiveHelper.borderRadius(10),
                              ),
                              borderSide:
                              const BorderSide(color: Colors.white),
                            ),
                          ),
                          onSubmitted: (_) => _submitManualText(),
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(10)),
                        ElevatedButton(
                          onPressed: _submitManualText,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            minimumSize: Size(
                              double.infinity,
                              ResponsiveHelper.height(44),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                ResponsiveHelper.borderRadius(10),
                              ),
                            ),
                          ),
                          child: Text(
                            "Submit",
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w700,
                              fontSize: ResponsiveHelper.fontSize(14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const Spacer(),

                // --- Mic & Processing ---
                Obx(() {
                  final bool isLoading = controller.isVoiceLoading.value;

                  return Column(
                    children: [
                      if (isLoading)
                        _buildProcessingIndicator()
                      else
                        _buildMicButton(),

                      SizedBox(height: ResponsiveHelper.spacing(20)),

                      Text(
                        isLoading
                            ? "Please wait a moment"
                            : (isListening
                            ? "Listening... Tap to stop"
                            : "Tap to record your meal"),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: ResponsiveHelper.fontSize(14),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  );
                }),

                SizedBox(height: ResponsiveHelper.spacing(40)),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProcessingIndicator() {
    return Container(
      height: ResponsiveHelper.height(116),
      alignment: Alignment.center,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.5, end: 1.0),
        duration: const Duration(milliseconds: 700),
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Text(
              "PROCESSING...",
              style: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveHelper.fontSize(22),
                fontWeight: FontWeight.w900,
                letterSpacing: 3,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMicButton() {
    return GestureDetector(
      onTap: _listen,
      child: Container(
        padding: ResponsiveHelper.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: ResponsiveHelper.borderWidth(2),
          ),
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: ResponsiveHelper.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Icon(
            isListening ? Icons.stop_rounded : Icons.mic_rounded,
            color: isListening ? Colors.redAccent : AppColors.primaryColor,
            size: ResponsiveHelper.iconSize(36),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedBar(int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150 + (index * 50)),
      margin:
      EdgeInsets.symmetric(horizontal: ResponsiveHelper.spacing(4)),
      width: ResponsiveHelper.width(6),
      height: isListening ? (20 + (soundLevel * (index + 2) * 3)) : 4,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(ResponsiveHelper.borderRadius(10)),
      ),
    );
  }
}