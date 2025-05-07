import 'package:conversio/models/chat.dart';
import 'package:conversio/models/user.dart';
import 'package:conversio/services/database.dart';
import 'package:conversio/utils/textstyle.dart';
import 'package:conversio/views/shared/loader.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:sizer/sizer.dart';

class ChatInfoScreen extends StatelessWidget {
  final Chat? chat;
  final ConversioUser? user;

  const ChatInfoScreen({super.key, this.chat, this.user});

  @override
  Widget build(BuildContext context) {
    if (chat == null && user == null) {
      return Scaffold(
        body: Center(
          child: Text(
            "Invalid chat or user",
            style: kTextStyle(context: context, size: 14),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          chat?.isGroup == true ? "Group Info" : "Contact Info",
          style: kTextStyle(
            context: context,
            size: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body:
          chat?.isGroup == true
              ? _buildGroupInfo(context)
              : _buildUserInfo(context),
    );
  }

  Widget _buildGroupInfo(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 2.h),
          CircleAvatar(
            radius: 50,
            backgroundImage:
                chat!.imageUrl != null ? NetworkImage(chat!.imageUrl!) : null,
            onBackgroundImageError: (_, __) {},
            child:
                chat!.imageUrl == null ? Icon(Iconsax.people, size: 50) : null,
          ),
          SizedBox(height: 2.h),
          Text(
            chat!.name ?? 'Unnamed Group',
            style: kTextStyle(
              context: context,
              size: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (chat!.description != null) ...[
            SizedBox(height: 1.h),
            Text(
              chat!.description!,
              style: kTextStyle(
                context: context,
                size: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
          SizedBox(height: 3.h),
          _buildInfoSection(
            context,
            "Created by",
            StreamBuilder<ConversioUser>(
              stream: DatabaseService().getUserInfo(uid: chat!.createdBy),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    snapshot.data?.name ?? 'Unknown User',
                    style: kTextStyle(context: context, size: 16),
                  );
                }
                return const Loader();
              },
            ),
          ),
          _buildInfoSection(
            context,
            "Created on",
            Text(
              chat!.createdAt?.toString().split('.')[0] ?? 'Unknown',
              style: kTextStyle(context: context, size: 16),
            ),
          ),
          SizedBox(height: 2.h),
          _buildMembersSection(context),
        ],
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 2.h),
          CircleAvatar(
            radius: 50,
            backgroundImage:
                user!.profileImgUrl != null
                    ? NetworkImage(user!.profileImgUrl!)
                    : null,
            onBackgroundImageError: (_, __) {},
            child:
                user!.profileImgUrl == null
                    ? Icon(Iconsax.user, size: 50)
                    : null,
          ),
          SizedBox(height: 2.h),
          Text(
            user!.name!,
            style: kTextStyle(
              context: context,
              size: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            user!.email!,
            style: kTextStyle(
              context: context,
              size: 16,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 3.h),
          _buildInfoSection(
            context,
            "Bio",
            Text(
              user!.bio ?? 'No bio available',
              style: kTextStyle(context: context, size: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, String title, Widget content) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: kTextStyle(
              context: context,
              size: 16,
              color: Colors.grey[600],
            ),
          ),
          content,
        ],
      ),
    );
  }

  Widget _buildMembersSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Text(
            "Members (${chat!.members.length})",
            style: kTextStyle(
              context: context,
              size: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: chat!.members.length,
          itemBuilder: (context, index) {
            final memberId = chat!.members[index];
            return StreamBuilder<ConversioUser>(
              stream: DatabaseService().getUserInfo(uid: memberId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const SizedBox();

                final member = snapshot.data!;
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage:
                        member.profileImgUrl != null
                            ? NetworkImage(member.profileImgUrl!)
                            : null,
                    onBackgroundImageError: (_, __) {},
                    child:
                        member.profileImgUrl == null
                            ? Icon(Iconsax.user)
                            : null,
                  ),
                  title: Text(
                    member.name!,
                    style: kTextStyle(context: context, size: 16),
                  ),
                  subtitle: Text(
                    member.email!,
                    style: kTextStyle(
                      context: context,
                      size: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  trailing:
                      chat!.admins?.contains(memberId) == true
                          ? Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 2.w,
                              vertical: 0.5.h,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              "Admin",
                              style: kTextStyle(
                                context: context,
                                size: 12,
                                color: Colors.white,
                              ),
                            ),
                          )
                          : null,
                );
              },
            );
          },
        ),
      ],
    );
  }
}
