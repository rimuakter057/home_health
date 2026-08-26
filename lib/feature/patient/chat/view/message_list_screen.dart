import 'package:ezygut/core/service/api_url.dart';
import 'package:ezygut/feature/patient/chat/controller/chat_controller.dart';
import 'package:ezygut/feature/patient/chat/widget/message_tile_widget.dart';
import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:ezygut/helper/time_converter/time_converter.dart';
import 'package:ezygut/share/widgets/app_bar/custom_app_bar.dart';
import 'package:ezygut/share/widgets/card/app_card.dart';
import 'package:ezygut/share/widgets/search_bar/search_bar.dart';
import 'package:ezygut/utils/app_const/app_const.dart';
import 'package:ezygut/utils/color/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'chat_details_screen.dart';

class MessageListScreen extends StatefulWidget {
  const MessageListScreen({super.key});

  @override
  State<MessageListScreen> createState() => _MessageListScreenState();
}

class _MessageListScreenState extends State<MessageListScreen> {
  final ChatController controller = Get.find<ChatController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.initChatList(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Messages'),
      body: Center(
        child: Container(
          constraints:
          BoxConstraints(maxWidth: ResponsiveHelper.maxContentWidth),
          padding: ResponsiveHelper.all(16),
          child: AppCard(
            child: Column(
              children: [
                // ── Search ──
                SearchField(
                  hintText: 'Quick search...',
                  onChanged: (val) => controller.onChatSearch(val),
                  suffixIcon: Padding(
                    padding: EdgeInsets.only(
                        right: ResponsiveHelper.spacing(12)),
                    child: Icon(
                      Icons.search,
                      size: ResponsiveHelper.iconSize(20),
                      color: AppColors.text2,
                    ),
                  ),
                ),

                SizedBox(height: ResponsiveHelper.spacing(16)),

                // ── List ──
                Expanded(
                  child: Obx(() {
                    if (controller.isLoadingChatList.value) {
                      return const _ChatListShimmer();
                    }

                    if (controller.userChatList.isEmpty) {
                      return Center(
                        child: Text(
                          controller.chatSearchQuery.value.isNotEmpty
                              ? 'No results found.'
                              : 'No conversations yet.',
                          style: TextStyle(
                            color: AppColors.text2,
                            fontSize: ResponsiveHelper.fontSize(14),
                          ),
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () async {
                        await controller
                            .fetchConversationList(context: context);
                      },
                      child: ListView.separated(
                        physics:
                        const AlwaysScrollableScrollPhysics(),
                        itemCount: controller.userChatList.length,
                        separatorBuilder: (_, __) => SizedBox(
                            height: ResponsiveHelper.spacing(12)),
                        itemBuilder: (context, index) {
                          final chat =
                          controller.userChatList[index];
                          final participant = chat.participant;
                          final lastMsg = chat.lastMessage;
                          final imageUrl =
                          participant?.profilePicture != null
                              ? "${ApiUrl.imageUrl}${participant!.profilePicture}"
                              : AppConst.unknown;

                          return MessageTile(
                            image: imageUrl,
                            name: participant?.name ?? 'Unknown',
                            subtitle: lastMsg?.isDeleted == true
                                ? 'This message was deleted'
                                : (lastMsg?.content ?? ''),
                            dateTime: DateConverter.formatTimeAgo(
                              chat.lastMessageAt ?? '',
                            ),
                            count: chat.unreadCount ?? 0,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ChatDetailScreen(
                                    conversationId:
                                    chat.conversationId ?? '',
                                    receiverId: chat.participant
                                        ?.receiverId ??
                                        '',
                                    receiverName:
                                    chat.participant?.name ??
                                        'Unknown',
                                    image: chat.participant
                                        ?.profilePicture ??
                                        AppConst.unknown,
                                  ),
                                ),
                              );

                              controller.markAsRead(
                                conversationId:
                                chat.conversationId ?? '',
                              );
                            },
                          );
                        },
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


///chat list shimmer=======




class _ChatListShimmer extends StatefulWidget {
  const _ChatListShimmer();

  @override
  State<_ChatListShimmer> createState() => _ChatListShimmerState();
}

class _ChatListShimmerState extends State<_ChatListShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _anim = Tween<double>(begin: -1.5, end: 1.5).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Widget _box({required double w, required double h, double radius = 8}) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          gradient: LinearGradient(
            begin: Alignment(_anim.value - 1, 0),
            end: Alignment(_anim.value + 1, 0),
            colors: [
              Colors.grey.shade300,
              Colors.grey.shade100,
              Colors.grey.shade300,
            ],
          ),
        ),
      ),
    );
  }

  Widget _tile(double sw) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.padding(16),
        vertical: ResponsiveHelper.spacing(6),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// avatar
          _box(
            w: ResponsiveHelper.iconSize(50),
            h: ResponsiveHelper.iconSize(50),
            radius: 25,
          ),

          SizedBox(width: ResponsiveHelper.width(12)),

          /// name + subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _box(w: sw * 0.38, h: ResponsiveHelper.height(15)),
                SizedBox(height: ResponsiveHelper.height(8)),
                _box(w: sw * 0.55, h: ResponsiveHelper.height(13)),
              ],
            ),
          ),

          SizedBox(width: ResponsiveHelper.width(8)),

          /// time + unread badge
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _box(w: sw * 0.12, h: ResponsiveHelper.height(12)),
              SizedBox(height: ResponsiveHelper.height(8)),
              _box(
                w: ResponsiveHelper.iconSize(20),
                h: ResponsiveHelper.iconSize(20),
                radius: 10,
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 8,
      separatorBuilder: (_, __) =>
          SizedBox(height: ResponsiveHelper.spacing(12)),
      itemBuilder: (_, __) => _tile(sw),
    );
  }
}