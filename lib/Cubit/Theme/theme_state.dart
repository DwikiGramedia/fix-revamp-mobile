part of 'theme_cubit.dart';

abstract class ThemeState extends Equatable {
  const ThemeState();

  @override
  List<Object?> get props => [];
}

class ThemeLoading extends ThemeState {}

class ThemeInitial extends ThemeState {}

class ChangeThemeAppSuccess extends ThemeState {
  final bool darkAppTheme;
  final ThemeData appThemeData;
  final Locale locale;
  const ChangeThemeAppSuccess({
    required this.darkAppTheme,
    required this.appThemeData,
    required this.locale,
  });
  @override
  // TODO: implement props
  List<Object?> get props => [darkAppTheme, appThemeData,locale];
}
