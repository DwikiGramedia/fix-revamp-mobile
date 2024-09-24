import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:revamp_eperpus_mobile/Utils/style.dart';
import 'package:revamp_eperpus_mobile/View/CustomWidget/button.dart';

class CardBorrowedBookHistory extends StatelessWidget {
  final String title;
  final DateTime dateBorrow;
  final bool isReviewed;
  final String image;
  final String name;
  final VoidCallback onTaped;
  const CardBorrowedBookHistory({
    Key? key,
    required this.title,
    required this.dateBorrow,
    required this.image,
    required this.isReviewed,
    required this.name,
    required this.onTaped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).canvasColor,
      ),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            width: 72,
            height: 94,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              image: DecorationImage(
                image: NetworkImage(image),
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 2,
                ),
                Text(
                  name,
                  style: Theme.of(context).textTheme.bodySmall,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Text(
                  '${AppLocalizations.of(context)!.borrowOn} ${dateBorrow.day}/${dateBorrow.month}/${dateBorrow.year} ',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          const SizedBox(width: 2),
          Container(
            margin: const EdgeInsets.only(right: 12, bottom: 4),
            height: 48,
            alignment: Alignment.bottomCenter,
            child: Button(
              color: isReviewed ? Colors.grey : primaryColor,
              title: AppLocalizations.of(context)!.sendReview,
              onTap: isReviewed ? null : onTaped,
              radius: 12,
              style: h6Title.copyWith(fontSize: 10, color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
