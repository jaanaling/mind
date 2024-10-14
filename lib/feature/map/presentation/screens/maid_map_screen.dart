import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:bubblebrain/core/theme/src/app_text_styles.dart';
import 'package:bubblebrain/feature/map/bloc/mind_map_bloc.dart';
import 'package:bubblebrain/feature/map/models/mind_map.dart';
import 'package:bubblebrain/routes/route_value.dart';
import 'package:bubblebrain/ui_kit/base_app_bar/widget/base_app_bar.dart';

class MindMapListScreen extends StatefulWidget {
  @override
  _MindMapListScreenState createState() => _MindMapListScreenState();
}

class _MindMapListScreenState extends State<MindMapListScreen> {
  @override
  void initState() {
    super.initState();
  }

  final List<String> _selectedTags = [];
  bool isSearch = false;
  TextEditingController searchController = TextEditingController();

  void _showTagFilterDialog() {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return CupertinoAlertDialog(
              title: const Text('Choose Tag').tr(),
              content: SingleChildScrollView(
                child: Column(
                  children: MapTags.values.map((tag) {
                    final bool isSelected = _selectedTags.contains(tag.name);
                    return GestureDetector(
                      onTap: () {
                        setDialogState(() {
                          if (isSelected) {
                            _selectedTags.remove(tag.name);
                          } else {
                            _selectedTags.add(tag.name);
                          }
                        });

                        setState(() {});
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              tag.name,
                              style: AppTextStyles.tabText,
                            ).tr(),
                            Icon(
                              isSelected
                                  ? Icons.check_box_rounded
                                  : Icons.check_box_outline_blank_rounded,
                              color: isSelected
                                  ? CupertinoColors.activeBlue
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              actions: [
                CupertinoDialogAction(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel').tr(),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: BaseAppBar(
        title: 'Your Mind Maps',
        titleWidget: isSearch
            ? TextField(
                controller: searchController,
                style: AppTextStyles.text.copyWith(
                  fontFamily: 'Roboto',
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  isDense: false,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: IntrinsicHeight(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.search,
                            color: Color(0xFFB6B6B6),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 1,
                            color: const Color(0xFFB6B6B6),
                          ),
                        ],
                      ),
                    ),
                  ),
                  hintText: 'Search'.tr(),
                  hintStyle: AppTextStyles.text.copyWith(
                    fontFamily: 'Roboto',
                    color: const Color.fromARGB(255, 212, 212, 212),
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(45.0)),
                    borderSide: BorderSide(color: Color(0xFFB6B6B6)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(45.0)),
                    borderSide: BorderSide(color: Color(0xFFB6B6B6)),
                  ),
                ),
                onTapOutside: (event) => FocusScope.of(context).unfocus(),
                onChanged: (value) {
                  setState(() {});
                },
              )
            : null,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            color: _selectedTags.isEmpty ? Colors.white : Colors.red,
            iconSize: 27,
            onPressed: _showTagFilterDialog,
          ),
          IconButton(
            icon: Icon(isSearch ? Icons.search_off : Icons.search),
            color: isSearch ? Colors.red : Colors.white,
            iconSize: 27,
            onPressed: () => setState(() {
              isSearch = !isSearch;
              searchController.clear();
            }),
          ),
        ],
      ),
      drawer: Drawer(
        child: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          removeBottom: true,
          child: ListView(
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(color: Color(0xFF320072)),
                child: Center(
                  child: Text(
                    'Settings',
                    style: AppTextStyles.splashText
                        .copyWith(fontFamily: 'Roboto', fontSize: 36),
                    textAlign: TextAlign.center,
                  ).tr(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  children: [
                    const Text('language').tr(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: DropdownButton<Locale>(
                        alignment: Alignment.center,
                        value: context.locale,
                        onChanged: (Locale? newLocale) {
                          if (newLocale != null) {
                            context.setLocale(newLocale);
                          }
                        },
                        items: context.supportedLocales.map((Locale locale) {
                          String localeName;
                          switch (locale.languageCode) {
                            case 'en':
                              localeName = 'English';
                            case 'fr':
                              localeName = 'Français';
                            case 'de':
                              localeName = 'Deutsch';
                            case 'es':
                              localeName = 'Español';
                            case 'it':
                              localeName = 'Italiano';
                            default:
                              localeName = locale.languageCode;
                          }
                          return DropdownMenuItem<Locale>(
                            value: locale,
                            child: Text(localeName),
                          );
                        }).toList(),
                      ),
                    ),
                    ],
                ),
              ), CupertinoButton(
                        child: Text('Privacy Policy').tr(),
                        onPressed: () => context.push(RouteValue.privicy.path),)
                 
            ],
          ),
        ),
      ),
      body: BlocBuilder<MindMapBloc, MindMapState>(
        builder: (context, state) {
          if (state is MindMapInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MindMapLoaded) {
            return _buildMindMapList(state.maps);
          } else if (state is MindMapError) {
            return Center(child: const Text('Error loading mind maps').tr());
          } else {
            return Container();
          }
        },
      ),
      floatingActionButton: CupertinoButton(
        onPressed: () {
          context.push(
            '${RouteValue.mindMap.path}/${RouteValue.mindMapCreate.path}',
          );
        },
        color: const Color(0xFF320072),
        borderRadius: BorderRadius.circular(30.0),
        child: const Icon(
          Icons.add,
          color: CupertinoColors.white,
        ),
      ),
    );
  }

  Widget _buildMindMapList(List<MindMap> maps) {
    if (maps.isEmpty) {
      return Center(child: const Text('No mind maps found').tr());
    }

    final filteredMaps = maps.where((map) {
      return _selectedTags.contains(map.tag) || _selectedTags.isEmpty;
    }).toList();

    final filteredSearchMaps = filteredMaps.where((map) {
      return map.title!
              .toLowerCase()
              .contains(searchController.text.toLowerCase()) ||
          searchController.text == '' ||
          searchController.text.isEmpty;
    }).toList();

    return ListView.builder(
      padding: const EdgeInsets.only(top: 16, bottom: 70),
      itemCount: filteredSearchMaps.length,
      itemBuilder: (context, index) {
        final map = filteredSearchMaps[index];
        return ListTile(
          title: Text(map.title ?? 'Untitled').tr(),
          subtitle: Text(map.description ?? '').tr(),
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Color(int.parse(map.nodes.first.color)),
              shape: BoxShape.circle,
            ),
          ),
          onTap: () {
            context.push(
              '${RouteValue.mindMap.path}/${RouteValue.mindMapCreate.path}/${RouteValue.mindMapEdit.path}',
              extra: map,
            );
          },
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              BlocProvider.of<MindMapBloc>(context).add(RemoveMap(map));
            },
          ),
        );
      },
    );
  }
}
