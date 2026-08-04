// lib/screens/components/session/instruction_panel.dart
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../../config/theme_config.dart';

class WorkspaceInstructionPanel extends StatefulWidget {
  final String kaggleUrl;

  const WorkspaceInstructionPanel({super.key, required this.kaggleUrl});

  @override
  State<WorkspaceInstructionPanel> createState() => _WorkspaceInstructionPanelState();
}

class _WorkspaceInstructionPanelState extends State<WorkspaceInstructionPanel> {
  bool _hasUploadedDatasetManual = false;
  bool _hasStartedCudaCellManual = false;

  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;
  bool _isTutorialExpanded = false;

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  void _toggleTutorialVideoPlayback() {
    setState(() {
      _isTutorialExpanded = !_isTutorialExpanded;
    });

    if (_isTutorialExpanded && _videoController == null) {
      _videoController = VideoPlayerController.asset("backend/assets/tutorial/tutorial.mp4")
        ..initialize().then((_) {
          if (!mounted) return;
          setState(() {
            _isVideoInitialized = true;
          });
          _videoController!.setLooping(true);
          _videoController!.play();
        });
    } else if (!_isTutorialExpanded && _videoController != null) {
      _videoController!.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.build_circle_outlined, color: CinemaMeshTheme.amberGold, size: 26),
                  const SizedBox(width: 10),
                  Text("User Manual Execution Steps", style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
              TextButton.icon(
                style: TextButton.styleFrom(foregroundColor: CinemaMeshTheme.primaryNeonRed),
                icon: Icon(_isTutorialExpanded ? Icons.expand_less : Icons.play_circle_fill_outlined, size: 18),
                label: Text(_isTutorialExpanded ? "Hide Demo" : "Watch Live Demo", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                onPressed: _toggleTutorialVideoPlayback,
              ),
            ],
          ),
          const SizedBox(height: 12),

          AnimatedCrossFade(
            duration: const Duration(milliseconds: 350),
            crossFadeState: _isTutorialExpanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            secondChild: const SizedBox.shrink(),
            firstChild: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(11),
                  child: _isVideoInitialized && _videoController != null
                      ? AspectRatio(
                    aspectRatio: _videoController!.value.aspectRatio,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        VideoPlayer(_videoController!),
                        VideoProgressIndicator(
                          _videoController!,
                          allowScrubbing: true,
                          colors: const VideoProgressColors(playedColor: CinemaMeshTheme.primaryNeonRed),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: IconButton(
                            icon: Icon(
                              _videoController!.value.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                              color: Colors.white70,
                              size: 28,
                            ),
                            onPressed: () {
                              setState(() {
                                _videoController!.value.isPlaying ? _videoController!.pause() : _videoController!.play();
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  )
                      : const SizedBox(height: 180, child: Center(child: CircularProgressIndicator(color: CinemaMeshTheme.primaryNeonRed))),
                ),
              ),
            ),
          ),

          const Text(
            "Kaggle isolates automated execution instances to prevent web spam. Please perform these infrastructure steps manually:",
            style: TextStyle(color: CinemaMeshTheme.mutedSubtleGrey, fontSize: 13, height: 1.4),
          ),
          const Divider(height: 32),

          CheckboxListTile(
            title: const Text("1. Download the workspace dataset asset and upload it as a Private Dataset to your profile account.", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            value: _hasUploadedDatasetManual,
            activeColor: CinemaMeshTheme.primaryNeonRed,
            onChanged: (bool? val) => setState(() => _hasUploadedDatasetManual = val ?? false),
          ),
          const SizedBox(height: 12),

          CheckboxListTile(
            title: const Text("2. Download the 'core_kernel.ipynb' notebook configuration, import it, assign T4x2 GPU hardware acceleration layers, and click 'Run All'.", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            value: _hasStartedCudaCellManual,
            activeColor: CinemaMeshTheme.primaryNeonRed,
            onChanged: (bool? val) => setState(() => _hasStartedCudaCellManual = val ?? false),
          ),
          const SizedBox(height: 32),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: CinemaMeshTheme.amberGold.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: CinemaMeshTheme.amberGold.withValues(alpha: 0.3)),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: CinemaMeshTheme.amberGold, size: 20),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Once cells finish compiling and print a live localtunnel connection string (e.g. 'https://loca.lt'), copy it and paste it inside the parsing terminal container block on the right.",
                    style: TextStyle(fontSize: 12, height: 1.4),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
