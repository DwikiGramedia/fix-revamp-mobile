import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revamp_eperpus_mobile/Cubit/Theme/theme_cubit.dart';
import 'package:revamp_eperpus_mobile/Utils/style.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeLanguageDialog extends StatefulWidget {
  ChangeLanguageDialog({
    Key? key,
  }) : super(key: key);

  @override
  State<ChangeLanguageDialog> createState() => _ChangeLanguageDialogState();
}

class _ChangeLanguageDialogState extends State<ChangeLanguageDialog> {
  String title = "";

  Language selectedLanguage = languageCode.first;

  String getTitle(String data) {
    switch (data) {
      case "en":
        return "English";
      case "id":
        return "Bahasa Indonesia";
      default:
        return "";
    }
  }

  void getLanguage() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String data = sharedPreferences.getString("codeLanguage") ?? "id";
    if(data == "en"){
      setState(() {
        selectedLanguage = languageCode.last;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getLanguage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    var size = MediaQuery.of(context).size;
    return AlertDialog(
      content: StatefulBuilder(
        // You need this, notice the parameters below:
        builder: (BuildContext context, StateSetter setState) {
          return SizedBox(
            height: size.height * 0.25,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  localization.changeLanguage,
                  style: h4Title,
                ),
                const SizedBox(height: 4),
                DropdownButton<Language>(
                  value: selectedLanguage,
                  items: languageCode.map<DropdownMenuItem<Language>>(
                    (Language value) {
                      return DropdownMenuItem<Language>(
                        value: value,
                        child: Text(value.text),
                      );
                    },
                  ).toList(),
                  onChanged: (Language? lang) {
                    context.read<ThemeCubit>().setLocale(lang!.code);
                    context.read<ThemeCubit>().getLocale();
                    setState(() {
                      selectedLanguage = lang;
                    });
                  },
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    context.read<ThemeCubit>().getLocale();
                    Navigator.pop(context);
                  },
                  child: Text(localization.close),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class Language {
  Language({
    required this.code,
    required this.text,
  });
  final String code;
  final String text;
}

List<Language> languageCode = [
  Language(code: "id", text: "Bahasa Indonesia"),
  Language(code: "en", text: "English"),
];
