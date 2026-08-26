import 'package:ezygut/helper/image_handler/image_handler.dart';
import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../utils/color/app_colors.dart';
import '../../../../../utils/extension/base_extension.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
class ChatBubble extends StatelessWidget {
  final bool isMe;
  final String message;
  final String messageType;
  final String? fileUrl;
  final String? fileName;

  const ChatBubble({
    super.key,
    required this.isMe,
    required this.message,
    this.messageType = 'text',
    this.fileUrl,
    this.fileName,
  });

  String _resolveFileUrl(String? url) {
    if (url == null || url.isEmpty) return '';
    return ImageHandler.imagesHandle(url);
  }

  Future<void> _openUrl(BuildContext context, String url) async {
    final resolvedUrl = _resolveFileUrl(url);
    debugPrint('🔗 Opening URL: $resolvedUrl');

    try {
      // Show loading
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Opening file...')),
        );
      }

      // Download to temp directory
      final dir = await getTemporaryDirectory();
      final fileName = resolvedUrl.split('/').last;
      final savePath = '${dir.path}/$fileName';

      final dio = Dio();
      await dio.download(resolvedUrl, savePath);
      debugPrint('✅ Downloaded to: $savePath');

      // Open with device default app
      final result = await OpenFilex.open(savePath);
      debugPrint('📂 Open result: ${result.message}');

      if (result.type != ResultType.done && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cannot open file: ${result.message}')),
        );
      }
    } catch (e) {
      debugPrint('❌ Error opening file: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }


  void _openFullScreenImage(BuildContext context, String url) {
    final resolvedUrl = _resolveFileUrl(url);
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.92),
        pageBuilder: (_, __, ___) => _FullScreenImageViewer(imageUrl: resolvedUrl),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDeleted = message == "This message was deleted";

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: ResponsiveHelper.height(6)),
        constraints: BoxConstraints(maxWidth: ResponsiveHelper.width(260)),
        decoration: BoxDecoration(
          color: isMe
              ? AppColors.primaryColor
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isMe ? 18 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 18),
          ),
          border: isMe
              ? null
              : Border.all(
            color: Colors.grey.withOpacity(0.2),
            width: 0.5,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isMe ? 18 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 18),
          ),
          child: _buildContent(context, isDeleted),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, bool isDeleted) {
    // ── deleted ──
    if (isDeleted) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.block_rounded,
                size: 13,
                color: isMe
                    ? Colors.white.withOpacity(0.5)
                    : Colors.grey.shade400),
            const SizedBox(width: 6),
            Text(
              "This message was deleted",
              style: TextStyle(
                fontSize: 13,
                fontStyle: FontStyle.italic,
                color: isMe
                    ? Colors.white.withOpacity(0.5)
                    : Colors.grey.shade400,
              ),
            ),
          ],
        ),
      );
    }

    // ✅ FIX: normalize messageType — lowercase + trim
    final type = messageType.toLowerCase().trim();

    debugPrint('💬 ChatBubble → type: $type | fileUrl: $fileUrl | fileName: $fileName');

    final resolvedFileUrl = _resolveFileUrl(fileUrl);

    // ── image ──
    // if (type == 'image' && resolvedFileUrl.isNotEmpty) {
    //   return GestureDetector(
    //     behavior: HitTestBehavior.opaque,
    //     onTap: () => _openFullScreenImage(context, resolvedFileUrl),
    //     child: Stack(
    //       children: [
    //         Image.network(
    //           resolvedFileUrl,
    //           width: ResponsiveHelper.width(220),
    //           height: ResponsiveHelper.height(170),
    //           fit: BoxFit.cover,
    //           errorBuilder: (_, __, ___) => _fileTile(
    //             context,
    //             icon: Icons.broken_image_outlined,
    //             label: fileName ?? 'Image',
    //             color: Colors.red.shade300,
    //           ),
    //           loadingBuilder: (_, child, progress) {
    //             if (progress == null) return child;
    //             return SizedBox(
    //               width: ResponsiveHelper.width(220),
    //               height: ResponsiveHelper.height(170),
    //               child: Center(
    //                 child: CircularProgressIndicator(
    //                   value: progress.expectedTotalBytes != null
    //                       ? progress.cumulativeBytesLoaded /
    //                       progress.expectedTotalBytes!
    //                       : null,
    //                   strokeWidth: 2,
    //                   color: isMe ? Colors.white : AppColors.primaryColor,
    //                 ),
    //               ),
    //             );
    //           },
    //         ),
    //
    //       ],
    //     ),
    //   );
    // }

    // ── pdf ──








///if image========================


    if (type == 'image' && resolvedFileUrl.isNotEmpty) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _openFullScreenImage(context, resolvedFileUrl),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: ResponsiveHelper.width(220),
            maxHeight: ResponsiveHelper.height(300),
          ),
          child: Image.network(
            resolvedFileUrl,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => _fileTile(
              context,
              icon: Icons.broken_image_outlined,
              label: fileName ?? 'Image',
              color: Colors.red.shade300,
            ),
            loadingBuilder: (_, child, progress) {
              if (progress == null) return child;

              return SizedBox(
                width: ResponsiveHelper.width(220),
                height: ResponsiveHelper.height(170),
                child: Center(
                  child: CircularProgressIndicator(
                    value: progress.expectedTotalBytes != null
                        ? progress.cumulativeBytesLoaded /
                        progress.expectedTotalBytes!
                        : null,
                    strokeWidth: 2,
                    color: isMe ? Colors.white : AppColors.primaryColor,
                  ),
                ),
              );
            },
          ),
        ),
      );
    }


    if (type == 'pdf') {
      return GestureDetector(
        onTap: () {
          if (resolvedFileUrl.isNotEmpty) {
            _openUrl(context, resolvedFileUrl);
          }
        },
        child: _fileTile(
          context,
          icon: Icons.picture_as_pdf_rounded,
          label: fileName ?? message,
          color: Colors.red.shade400,
          extension: 'PDF',
        ),
      );
    }

    // ── generic file ──
    if (type == 'file') {
      return GestureDetector(
        onTap: () {
          if (resolvedFileUrl.isNotEmpty) {
            _openUrl(context, resolvedFileUrl);
          }
        },
        child: _fileTile(
          context,
          icon: Icons.insert_drive_file_rounded,
          label: fileName ?? message,
          color: Colors.blue.shade400,
          extension: _getExtension(fileName ?? message),
        ),
      );
    }

    // ── text ──
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Text(
        message,
        style: TextStyle(
          fontSize: 14,
          height: 1.45,
          color: isMe
              ? Colors.white
              : Theme.of(context).textTheme.bodyMedium?.color,
        ),
      ),
    );
  }

  Widget _fileTile(
      BuildContext context, {
        required IconData icon,
        required String label,
        required Color color,
        String? extension,
      }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isMe
                        ? Colors.white
                        : Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
                if (extension != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    extension,
                    style: TextStyle(
                      fontSize: 11,
                      color: isMe
                          ? Colors.white.withOpacity(0.6)
                          : Colors.grey.shade500,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.north_east_rounded,
            size: 16,
            color: isMe ? Colors.white.withOpacity(0.6) : Colors.grey.shade400,
          ),
        ],
      ),
    );
  }

  String _getExtension(String name) {
    final parts = name.split('.');
    if (parts.length > 1) return parts.last.toUpperCase();
    return 'FILE';
  }
}


// ─────────────────────────────────────────────────────────────────────────────
// Full Screen Image Viewer
// ─────────────────────────────────────────────────────────────────────────────
class _FullScreenImageViewer extends StatefulWidget {
  final String imageUrl;
  const _FullScreenImageViewer({required this.imageUrl});

  @override
  State<_FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<_FullScreenImageViewer> {
  final TransformationController _ctrl = TransformationController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Stack(
          children: [
            Container(color: Colors.black.withOpacity(0.92)),
            Center(
              child: GestureDetector(
                onTap: () {},
                child: InteractiveViewer(
                  transformationController: _ctrl,
                  minScale: 0.5,
                  maxScale: 5.0,
                  child: Image.network(
                    widget.imageUrl,
                    fit: BoxFit.contain,
                    loadingBuilder: (_, child, progress) {
                      if (progress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      );
                    },
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.broken_image_outlined,
                      color: Colors.white30,
                      size: 64,
                    ),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    margin: const EdgeInsets.all(14),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close_rounded,
                        color: Colors.white, size: 20),
                  ),
                ),
              ),
            ),
            const SafeArea(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 24),
                  child: Text(
                    'Pinch to zoom  ·  tap outside to close',
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}