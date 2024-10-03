import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bubblebrain/feature/map/models/mind_map.dart';
import 'package:bubblebrain/feature/map/models/node.dart';
import 'package:bubblebrain/routes/route_value.dart';
import 'package:bubblebrain/ui_kit/base_app_bar/widget/base_app_bar.dart';

class CreateMindMapScreen extends StatefulWidget {
  @override
  _CreateMindMapScreenState createState() => _CreateMindMapScreenState();
}

class _CreateMindMapScreenState extends State<CreateMindMapScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedTemplate;
  String? _selectedTag;

  String? tempSelectedTag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: BaseAppBar(
        title: 'Create New Mind Map'.tr(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Main Idea'.tr(),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  borderSide: BorderSide(color: Color(0xFFB6B6B6)),
                ),
              ),
              onTapOutside: (event) => FocusScope.of(context).unfocus(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Idea Description'.tr(),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  borderSide: BorderSide(color: Color(0xFFB6B6B6)),
                ),
              ),
              onTapOutside: (event) => FocusScope.of(context).unfocus(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Choose Tag').tr(),
                CupertinoButton(
                  child: Text(_selectedTag ?? MapTags.untagged.name),
                  onPressed: () {
                    showCupertinoModalPopup(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          height: 300,
                          color: CupertinoColors.darkBackgroundGray
                              .withOpacity(0.95),
                          child: Column(
                            children: [
                              Expanded(
                                child: CupertinoPicker(
                                  itemExtent: 32.0,
                                  onSelectedItemChanged: (int index) {
                                    setState(() {
                                      tempSelectedTag =
                                          MapTags.values[index].name;
                                    });
                                  },
                                  children: MapTags.values.map((tag) {
                                    return Text(
                                      tag.name,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ).tr();
                                  }).toList(),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  CupertinoButton(
                                    child: const Text('Cancel').tr(),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  CupertinoButton(
                                    child: const Text('Confirm').tr(),
                                    onPressed: () {
                                      setState(() {
                                        _selectedTag = tempSelectedTag;
                                      });
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: CupertinoButton(
                color: const Color.fromARGB(255, 56, 0, 129),
                onPressed: () {
                  context.pushReplacement(
                    '${RouteValue.mindMap.path}/${RouteValue.mindMapCreate.path}/${RouteValue.mindMapEdit.path}',
                    extra: MindMap(
                      id: _generateId(),
                      title: _titleController.text,
                      description: _descriptionController.text,
                      template: _selectedTemplate ?? MapTemples.Untempled.name,
                      tag: _selectedTag ?? NodeTag.untagged.name,
                      nodes: [
                        Node(
                          tag: NodeTag.untagged.name,
                          id: _generateId(),
                          title: _titleController.text,
                          position: Offset(
                            MediaQuery.of(context).size.width / 3,
                            MediaQuery.of(context).size.height / 4,
                          ),
                          nodeType: NodeType.idea.name,
                          color: '0xFF1AACFF',
                          description: _descriptionController.text,
                          size: 180,
                        ),
                      ],
                      connections: [],
                    ),
                  );
                },
                child: const Text(
                  'Create Map',
                  style: TextStyle(color: Colors.white),
                ).tr(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Row(
                children: [
                  const Expanded(
                    child: Divider(
                      height: 1,
                      color: Colors.black,
                      thickness: 1,
                      endIndent: 8,
                    ),
                  ),
                  const Text('OR').tr(),
                  const Expanded(
                    child: Divider(
                      indent: 8,
                      height: 1,
                      color: Colors.black,
                      thickness: 1,
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: CupertinoButton(
                color: const Color.fromARGB(255, 56, 0, 129),
                child: Text(
                  _selectedTemplate ?? 'Choose Template',
                  style: const TextStyle(color: Colors.white),
                ).tr(),
                onPressed: () {
                  showCupertinoModalPopup<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return CupertinoActionSheet(
                        title: const Text('Choose Template').tr(),
                        actions: MapTemples.values.map((template) {
                          return CupertinoActionSheetAction(
                            onPressed: () {
                              setState(() {
                                _selectedTemplate = template.name;
                              });
                              Navigator.pop(context);
                              context.pushReplacement(
                                '${RouteValue.mindMap.path}/${RouteValue.mindMapCreate.path}/${RouteValue.mindMapEdit.path}',
                                extra: MindMap(
                                  id: _generateId(),
                                  title: '',
                                  description: '',
                                  template: _selectedTemplate ??
                                      MapTemples.Untempled.name,
                                  tag: _selectedTag ?? NodeTag.untagged.name,
                                  nodes: [],
                                  connections: [],
                                ),
                              );
                            },
                            child: Text(template.name).tr(),
                          );
                        }).toList(),
                        cancelButton: CupertinoActionSheetAction(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel').tr(),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _generateId() {
    return Random().nextInt(100000).toString();
  }
}
