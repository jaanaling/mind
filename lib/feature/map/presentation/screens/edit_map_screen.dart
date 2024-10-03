import 'dart:math';
import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:bubblebrain/core/theme/src/app_text_styles.dart';
import 'package:bubblebrain/core/utils/log.dart';
import 'package:bubblebrain/feature/map/bloc/mind_map_bloc.dart';
import 'package:bubblebrain/feature/map/models/mind_map.dart';
import 'package:bubblebrain/feature/map/models/node.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:bubblebrain/ui_kit/base_app_bar/widget/base_app_bar.dart';

class EditMindMapScreen extends StatefulWidget {
  final MindMap map;
  const EditMindMapScreen({required this.map});
  @override
  _EditMindMapScreenState createState() => _EditMindMapScreenState();
}

class _EditMindMapScreenState extends State<EditMindMapScreen> {
  final TextEditingController _titleController = TextEditingController();
  List<Node> _nodes = [];
  List<Connection> _connections = [];
  Node? _selectedNode;
  bool _isConnecting = false;
  String? selectedScheme;
  String? _id;
  final List<String> _selectedTags = [];

  @override
  void initState() {
    _id = widget.map.id;
    _titleController.text = widget.map.title ?? 'Untitled';
    _nodes = widget.map.nodes;
    _connections = widget.map.connections;

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.map.nodes.length <= 1) {
      createTemplate(widget.map.template);
    }
  }

  final List<Map<String, dynamic>> colorSchemes = [
    {
      'name': 'Classic',
      'colors': {
        'Idea': {'name': 'Light Green', 'value': 0xFF90EE90},
        'Task': {'name': 'Blue', 'value': 0xFF0000FF},
        'Resource': {'name': 'Yellow', 'value': 0xFFFFFF00},
        'Problem': {'name': 'Red', 'value': 0xFFFF0000},
        'Solution': {'name': 'Purple', 'value': 0xFF800080},
      },
    },
    {
      'name': 'Monochrome',
      'colors': {
        'Idea': {'name': 'Light Gray', 'value': 0xFFD3D3D3},
        'Task': {'name': 'Dark Gray', 'value': 0xFFA9A9A9},
        'Resource': {'name': 'Silver', 'value': 0xFFC0C0C0},
        'Problem': {'name': 'Black', 'value': 0xFF000000},
        'Solution': {'name': 'White', 'value': 0xFFFFFFFF},
      },
    },
    {
      'name': 'Warm Palette',
      'colors': {
        'Idea': {'name': 'Orange', 'value': 0xFFFFA500},
        'Task': {'name': 'Burgundy', 'value': 0xFF800020},
        'Resource': {'name': 'Peach', 'value': 0xFFFFE5B4},
        'Problem': {'name': 'Dark Red', 'value': 0xFF8B0000},
        'Solution': {'name': 'Brown', 'value': 0xFFA52A2A},
      },
    },
    {
      'name': 'Cool Palette',
      'colors': {
        'Idea': {'name': 'Sky Blue', 'value': 0xFF87CEEB},
        'Task': {'name': 'Icy Blue', 'value': 0xFFAFEEEE},
        'Resource': {'name': 'Turquoise', 'value': 0xFF40E0D0},
        'Problem': {'name': 'Dark Blue', 'value': 0xFF00008B},
        'Solution': {'name': 'Sea Wave', 'value': 0xFF2E8B57},
      },
    },
    {
      'name': 'Pastel Palette',
      'colors': {
        'Idea': {'name': 'Light Pink', 'value': 0xFFFFB6C1},
        'Task': {'name': 'Lavender', 'value': 0xFFE6E6FA},
        'Resource': {'name': 'Pale Yellow', 'value': 0xFFFFFACD},
        'Problem': {'name': 'Pastel Coral', 'value': 0xFFFF6F61},
        'Solution': {'name': 'Light Green', 'value': 0xFF98FB98},
      },
    },
  ];

  void _showColorSchemeDialog() {
    showCupertinoDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Select Color Scheme').tr(),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: colorSchemes.map((scheme) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedScheme = scheme['name'] as String;
                  });
                  Navigator.of(context).pop();
                  _showConfirmationDialog(scheme);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    children: [
                      Text(
                        scheme['name'] as String,
                        style: AppTextStyles.subtitle2,
                      ).tr(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: scheme['colors'].entries.map<Widget>(
                            (entry) {
                              final colorValue = entry.value['value'];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: Color(colorValue as int),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              );
                            },
                          ).toList() as List<Widget>,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('Cancel').tr(),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showConfirmationDialog(Map<String, dynamic> scheme) {
    showCupertinoDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Confirm Selection').tr(),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: scheme['colors'].entries.map<Widget>(
              (entry) {
                final colorValue = entry.value['value'];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Color(colorValue as int),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${'${entry.key}'.tr()} : ${'${entry.value['name']}'.tr()}',
                        style: AppTextStyles.tabText.copyWith(fontSize: 12),
                      ).tr(),
                    ],
                  ),
                );
              },
            ).toList() as List<Widget>,
          ),
          actions: [
            CupertinoDialogAction(
              child: const Text('Confirm').tr(),
              onPressed: () {
                setState(() {
                  for (final node in _nodes) {
                    node.color = scheme['colors'][node.nodeType]['value']
                        .toRadixString(10) as String;
                  }
                });
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: const Text('Cancel').tr(),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: BaseAppBar(
        title: 'Edit Mind Map',
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              if (widget.map.nodes.isNotEmpty) {
                logger.d(_nodes.map((node) => node.title));
                context.read<MindMapBloc>().add(
                      SaveMap(
                        MindMap(
                          id: _id!,
                          title: _nodes.first.title != ''
                              ? _nodes.first.title
                              : 'Untitled',
                          nodes: _nodes,
                          connections: _connections,
                          description: _nodes.first.description,
                          template: MapTemples.Untempled.name,
                          tag: widget.map.tag,
                        ),
                      ),
                    );
              } else {
                context.read<MindMapBloc>().add(RemoveMap(widget.map));
              }

              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          ..._buildNodesAndConnections(),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.3,
              margin: const EdgeInsets.only(bottom: 15.0, left: 15),
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 19),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color: Color(0xFF313131),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: _addNode,
                    icon: const Icon(Icons.add),
                    iconSize: 27,
                    color: Colors.white,
                  ),
                  IconButton(
                    icon: Icon(_isConnecting ? Icons.link_off : Icons.link),
                    color: _isConnecting ? Colors.red : Colors.white,
                    iconSize: 27,
                    onPressed: () {
                      setState(() {
                        _isConnecting = !_isConnecting;
                        _selectedNode = null;
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.filter_alt),
                    color: _selectedTags.isEmpty ? Colors.white : Colors.red,
                    iconSize: 27,
                    onPressed: _showTagFilterDialog,
                  ),
                  IconButton(
                    icon: const Icon(Icons.palette),
                    color: Colors.white,
                    iconSize: 27,
                    onPressed: _showColorSchemeDialog,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

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
                  children: NodeTag.values.map((tag) {
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

  List<Widget> _buildNodesAndConnections() {
    return [
      ..._buildConnections(),
      ..._nodes.map((node) => _buildNode(node)),
    ];
  }

  double _initialNodeSize = 0.0;

  Widget _buildNode(Node node) {
    return Positioned(
      left: node.position.dx,
      top: node.position.dy,
      child: GestureDetector(
        onScaleStart: (details) {
          _initialNodeSize = node.size;
        },
        onScaleUpdate: (details) {
          setState(() {
            node.position += details.focalPointDelta;

            final double newSize =
                (_initialNodeSize * details.scale).clamp(50.0, 300.0);

            if (newSize > 50.0) {
              node.size = newSize;
            }
          });
        },
        onTap: () {
          if (!_isConnecting) {
            _showNodeEditDialog(node, null);
          } else {
            _handleNodeConnection(node);
          }
        },
        child: Opacity(
          opacity: _selectedTags.contains(node.tag) || _selectedTags.isEmpty
              ? 1
              : 0.0,
          child: Container(
            padding: const EdgeInsets.all(20.0),
            child: _buildNodeShape(node),
          ),
        ),
      ),
    );
  }

  Widget _buildNodeShape(Node node) {
    ShapeBorder shapeBorder;
    Widget nodeWidget;

    switch (node.nodeType) {
      case 'Idea':
        shapeBorder = const CircleBorder(side: BorderSide());
      case 'Task':
        shapeBorder = const StadiumBorder(
          side: BorderSide(width: 3.0),
        );
      case 'Resource':
        shapeBorder = BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: const BorderSide(width: 2.0),
        );
        nodeWidget = _buildDashedBorderNode(node, shapeBorder);
        return nodeWidget;
      case 'Problem':
        shapeBorder = RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
          side: const BorderSide(width: 2.0),
        );
      case 'Solution':
        shapeBorder = const StadiumBorder(
          side: BorderSide(width: 2.0),
        );
        return _buildDottedBorderNode(node, shapeBorder);
      default:
        shapeBorder = const CircleBorder(side: BorderSide());
    }

    return _buildSolidBorderNode(node, shapeBorder);
  }

  Widget _buildSolidBorderNode(Node node, ShapeBorder shapeBorder) {
    return Container(
      width: node.size,
      height: node.size,
      decoration: ShapeDecoration(
        color: _selectedNode == node
            ? Colors.red.shade500
            : Color(int.parse(node.color)),
        shape: shapeBorder,
      ),
      child: _nodeText(node),
    );
  }

  Widget _buildDashedBorderNode(Node node, ShapeBorder shapeBorder) {
    return CustomPaint(
      size: Size(node.size, node.size),
      painter: DashedBorderPainter(),
      child: _buildSolidBorderNode(node, shapeBorder),
    );
  }

  Widget _buildDottedBorderNode(Node node, ShapeBorder shapeBorder) {
    return CustomPaint(
      size: Size(node.size, node.size),
      painter: DottedBorderPainter(),
      child: _buildSolidBorderNode(node, shapeBorder),
    );
  }

  Padding _nodeText(Node node) {
    return Padding(
      padding: EdgeInsets.all(node.size / 5.5),
      child: Center(
        child: Text(
          node.title != '' ? node.title ?? 'Untitled' : 'Untitled',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'BN',
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ).tr(),
      ),
    );
  }

  void _showNodeEditDialog(Node node, Function()? saveCallback) {
    final TextEditingController titleController =
        TextEditingController(text: node.title);
    final TextEditingController descriptionController =
        TextEditingController(text: node.description);
    final Color selectedColor = Color(int.parse(node.color));
    String selectedNodeType = node.nodeType;
    String selectedTag = node.tag;
    String? tempTitle = node.title;
    String? tempDescription = node.description;
    double tempSize = node.size;
    Color tempColor = selectedColor;
    String tempSelectedNodeType = selectedNodeType;
    String tempSelectedTag = selectedTag;
    bool isViewMode = true;

    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return CupertinoAlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      saveCallback == null && isViewMode
                          ? 'Node Info'
                          : 'Edit Node',
                      textAlign: TextAlign.start,
                    ).tr(),
                  ),
                  if (saveCallback == null)
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            isViewMode ? Icons.edit : Icons.remove_red_eye,
                          ),
                          onPressed: () {
                            setDialogState(() {
                              isViewMode = !isViewMode;
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              context
                                  .read<MindMapBloc>()
                                  .add(RemoveNode(widget.map.id, node.id));
                              _nodes.remove(node);
                            });
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                ],
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  // Если режим просмотра активен
                  if (saveCallback == null && isViewMode) ...[
                    Text(
                      "${'Title'.tr()}: ${'${node.title}'.tr()}",
                      style: AppTextStyles.tabText.copyWith(
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.start,
                    ).tr(),
                    const SizedBox(height: 8),
                    Text(
                      "${'Description'.tr()}: ${'${node.description}'.tr()}",
                      style: AppTextStyles.tabText.copyWith(
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.start,
                    ).tr(),
                    Text(
                      '${'Tag'.tr()}: ${node.tag.tr()}',
                      style: AppTextStyles.tabText.copyWith(
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.start,
                    ).tr(),
                    const SizedBox(height: 16),
                  ] else ...[
                    CupertinoTextField(
                      controller: titleController,
                      placeholder: 'Title'.tr(),
                      placeholderStyle: AppTextStyles.tabText
                          .copyWith(color: Colors.white.withOpacity(0.7)),
                      style: AppTextStyles.tabText,
                      onTapOutside: (e) => FocusScope.of(context).unfocus,
                      onChanged: (value) {
                        setDialogState(() {
                          tempTitle = value;
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    CupertinoTextField(
                      controller: descriptionController,
                      placeholder: 'Description'.tr(),
                      placeholderStyle: AppTextStyles.tabText
                          .copyWith(color: Colors.white.withOpacity(0.7)),
                      style: AppTextStyles.tabText,
                      onTapOutside: (e) => FocusScope.of(context).unfocus,
                      maxLines: 4,
                      onChanged: (value) {
                        setDialogState(() {
                          tempDescription = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    CupertinoSlider(
                      value: tempSize,
                      thumbColor: tempColor,
                      min: 50.0,
                      max: 200.0,
                      onChanged: (double value) {
                        setDialogState(() {
                          tempSize = value;
                        });
                      },
                    ),
                    Text('${'Size'.tr()} ${tempSize.toStringAsFixed(1)}'),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text(
                          'Type',
                          style: AppTextStyles.tabText,
                        ).tr(),
                        CupertinoButton(
                          child: Text(
                            tempSelectedNodeType,
                            style: AppTextStyles.tabText
                                .copyWith(color: CupertinoColors.activeBlue),
                          ).tr(),
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
                                            setDialogState(() {
                                              tempSelectedNodeType =
                                                  NodeType.values[index].name;
                                            });
                                          },
                                          children: NodeType.values.map((type) {
                                            return Text(
                                              type.name,
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
                                              setDialogState(() {
                                                selectedNodeType =
                                                    tempSelectedNodeType;
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
                    Row(
                      children: [
                        const Text('Tag', style: AppTextStyles.tabText).tr(),
                        CupertinoButton(
                          child: Text(
                            tempSelectedTag,
                            style: AppTextStyles.tabText
                                .copyWith(color: CupertinoColors.activeBlue),
                          ).tr(),
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
                                            setDialogState(() {
                                              tempSelectedTag =
                                                  NodeTag.values[index].name;
                                            });
                                          },
                                          children: NodeTag.values.map((tag) {
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
                                              setDialogState(() {
                                                selectedTag = tempSelectedTag;
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
                    Row(
                      children: [
                        const Text(
                          'Choose Color',
                          style: AppTextStyles.tabText,
                        ).tr(),
                        const Gap(8),
                        GestureDetector(
                          onTap: () {
                            showCupertinoDialog(
                              context: context,
                              builder: (BuildContext context) {
                                Color tColor = tempColor;
                                return CupertinoAlertDialog(
                                  content: SlidePicker(
                                    sliderTextStyle: AppTextStyles.tabText
                                        .copyWith(fontSize: 12),
                                    pickerColor: tempColor,
                                    onColorChanged: (color) {
                                      setDialogState(() {
                                        tColor = color;
                                      });
                                    },
                                  ),
                                  actions: [
                                    CupertinoDialogAction(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancel').tr(),
                                    ),
                                    CupertinoDialogAction(
                                      onPressed: () {
                                        setDialogState(() {
                                          tempColor = tColor;
                                        });

                                        Navigator.pop(context);
                                      },
                                      child: const Text('Confirm').tr(),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: tempColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
              actions: [
                CupertinoDialogAction(
                  child: const Text('Cancel').tr(),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                if (saveCallback != null || !isViewMode)
                  CupertinoDialogAction(
                    child: const Text('Confirm').tr(),
                    onPressed: () {
                      setState(() {
                        node.title = tempTitle;
                        node.tag = tempSelectedTag;
                        node.description = tempDescription;
                        node.size = tempSize;
                        node.color = tempColor.value.toRadixString(10);
                        node.nodeType = tempSelectedNodeType;

                        if (saveCallback != null) {
                          saveCallback();
                        }
                      });
                      Navigator.of(context).pop();
                    },
                  ),
              ],
            );
          },
        );
      },
    );
  }

  void _handleNodeConnection(Node node) {
    setState(() {
      if (_selectedNode == null) {
        _selectedNode = node;
      } else {
        if (_selectedNode == node) {
          _selectedNode = null;
        } else {
          final existingConnection = _connections.firstWhere(
            (conn) =>
                (conn.nodeId1 == _selectedNode!.id &&
                    conn.nodeId2 == node.id) ||
                (conn.nodeId1 == node.id && conn.nodeId2 == _selectedNode!.id),
            orElse: () => Connection(nodeId1: '', nodeId2: ''),
          );

          if (existingConnection.nodeId1.isEmpty) {
            _connections
                .add(Connection(nodeId1: _selectedNode!.id, nodeId2: node.id));
          } else {
            _connections.removeWhere(
              (conn) =>
                  (conn.nodeId1 == _selectedNode!.id &&
                      conn.nodeId2 == node.id) ||
                  (conn.nodeId1 == node.id &&
                      conn.nodeId2 == _selectedNode!.id),
            );
          }
          _selectedNode = null;
        }
      }
    });
  }

  List<Widget> _buildConnections() {
    return _connections.map((connection) {
      final node1 = _nodes.firstWhere((n) => n.id == connection.nodeId1);
      final node2 = _nodes.firstWhere((n) => n.id == connection.nodeId2);

      return Positioned(
        left: 0,
        top: 0,
        child: Opacity(
          opacity: _selectedTags.contains(node1.tag) &&
                      _selectedTags.contains(node2.tag) ||
                  _selectedTags.isEmpty
              ? 1
              : 0.0,
          child: CustomPaint(
            size: const Size(
              400,
              400,
            ),
            painter: ConnectionPainter(
              start: Offset(
                node1.position.dx + node1.size / 2,
                node1.position.dy + node1.size / 2,
              ),
              end: Offset(
                node2.position.dx + node2.size / 2,
                node2.position.dy + node2.size / 2,
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  String _generateId() {
    return Random().nextInt(100000).toString();
  }

  void _addNode() {
    final node = Node(
      tag: NodeTag.untagged.name,
      id: _generateId(),
      title: 'Node ${_nodes.length + 1}',
      position: Offset(
        100 + Random().nextInt(200).toDouble(),
        100 + Random().nextInt(200).toDouble(),
      ),
      nodeType: NodeType.idea.name,
      color: '0xFFAAA222',
      description: '',
      size: 50,
    );

    _showNodeEditDialog(
      node,
      () => setState(() {
        context.read<MindMapBloc>().add(AddNode(_id!, node));
        _nodes.add(node);
      }),
    );
  }

  void createTemplate(String template) {
    List<Node> templateNodes = [];

    final screenSize = MediaQuery.of(context).size;

    switch (template) {
      case 'Project Planning':
        templateNodes = [
          Node(
            tag: NodeTag.untagged.name,
            id: _generateId(),
            title: 'Project Goals',
            position: Offset(screenSize.width * 0.2, screenSize.height * 0.1),
            nodeType: NodeType.idea.name,
            color: '0xFF42A5F5',
            description: 'Define the main goals of your project.',
            size: 150,
          ),
          Node(
            tag: NodeTag.untagged.name,
            id: _generateId(),
            title: 'Execution Stages',
            position: Offset(screenSize.width * 0.3, screenSize.height * 0.2),
            nodeType: NodeType.solution.name,
            color: '0xFF42A5F5',
            description: 'Break the project down into stages.',
            size: 90,
          ),
          Node(
            tag: NodeTag.untagged.name,
            id: _generateId(),
            title: 'Resources',
            position: Offset(screenSize.width * 0.1, screenSize.height * 0.3),
            nodeType: NodeType.resource.name,
            color: '0xFF42A5F5',
            description: 'List the resources required to complete the project.',
            size: 90,
          ),
          Node(
            tag: NodeTag.untagged.name,
            id: _generateId(),
            title: 'Risks',
            position: Offset(screenSize.width * 0.3, screenSize.height * 0.35),
            nodeType: NodeType.problem.name,
            color: '0xFFFFC107',
            description: 'Identify potential risks for the project.',
            size: 90,
          ),
          Node(
            tag: NodeTag.untagged.name,
            id: _generateId(),
            title: 'Responsible Persons',
            position: Offset(screenSize.width * 0.25, screenSize.height * 0.1),
            nodeType: NodeType.resource.name,
            color: '0xFF66BB6A',
            description: 'Determine who is responsible for the tasks.',
            size: 90,
          ),
        ];

      case 'Brainstorming':
        templateNodes = [
          Node(
            tag: NodeTag.untagged.name,
            id: _generateId(),
            title: 'Main Idea',
            position: Offset(screenSize.width * 0.3, screenSize.height * 0.1),
            nodeType: NodeType.idea.name,
            color: '0xFF42A5F5',
            description: 'Write down the main theme.',
            size: 150,
          ),
          Node(
            tag: NodeTag.untagged.name,
            id: _generateId(),
            title: 'Ideas',
            position: Offset(screenSize.width * 0.1, screenSize.height * 0.25),
            nodeType: NodeType.idea.name,
            color: '0xFF42A5F5',
            description: 'Write down all ideas that come to mind.',
            size: 90,
          ),
          Node(
            tag: NodeTag.untagged.name,
            id: _generateId(),
            title: 'Solutions',
            position: Offset(screenSize.width * 0.25, screenSize.height * 0.25),
            nodeType: NodeType.solution.name,
            color: '0xFF66BB6A',
            description: 'Think of possible solutions.',
            size: 90,
          ),
        ];

      case 'Study Plan':
        templateNodes = [
          Node(
            tag: NodeTag.untagged.name,
            id: _generateId(),
            title: 'Topics to Study',
            position: Offset(screenSize.width * 0.3, screenSize.height * 0.1),
            nodeType: NodeType.idea.name,
            color: '0xFF42A5F5',
            description: 'List of topics to study.',
            size: 150,
          ),
          Node(
            tag: NodeTag.untagged.name,
            id: _generateId(),
            title: 'Resources',
            position: Offset(screenSize.width * 0.1, screenSize.height * 0.25),
            nodeType: NodeType.resource.name,
            color: '0xFF66BB6A',
            description: 'Books, videos, and articles.',
            size: 90,
          ),
          Node(
            tag: NodeTag.untagged.name,
            id: _generateId(),
            title: 'Tasks',
            position: Offset(screenSize.width * 0.25, screenSize.height * 0.25),
            nodeType: NodeType.resource.name,
            color: '0xFF42A5F5',
            description: 'Tasks for each topic.',
            size: 90,
          ),
        ];

      case 'Problem Analysis and Solutions':
        templateNodes = [
          Node(
            tag: NodeTag.untagged.name,
            id: _generateId(),
            title: 'Problem Description',
            position: Offset(screenSize.width * 0.3, screenSize.height * 0.1),
            nodeType: NodeType.problem.name,
            color: '0xFFFFC107',
            description: 'A clear description of the problem.',
            size: 150,
          ),
          Node(
            tag: NodeTag.untagged.name,
            id: _generateId(),
            title: 'Causes',
            position: Offset(screenSize.width * 0.1, screenSize.height * 0.25),
            nodeType: NodeType.idea.name,
            color: '0xFF42A5F5',
            description: 'Reasons behind the problem.',
            size: 90,
          ),
          Node(
            tag: NodeTag.untagged.name,
            id: _generateId(),
            title: 'Solutions',
            position: Offset(screenSize.width * 0.25, screenSize.height * 0.25),
            nodeType: NodeType.solution.name,
            color: '0xFF66BB6A',
            description: 'Possible solutions to the problem.',
            size: 90,
          ),
        ];

      case 'Creating a Product':
        templateNodes = [
          Node(
            tag: NodeTag.untagged.name,
            id: _generateId(),
            title: 'Product Idea',
            position: Offset(screenSize.width * 0.3, screenSize.height * 0.1),
            nodeType: NodeType.idea.name,
            color: '0xFF42A5F5',
            description: 'The overall idea of your product.',
            size: 150,
          ),
          Node(
            tag: NodeTag.untagged.name,
            id: _generateId(),
            title: 'Target Audience',
            position: Offset(screenSize.width * 0.1, screenSize.height * 0.25),
            nodeType: NodeType.resource.name,
            color: '0xFF66BB6A',
            description: 'Who will use the product.',
            size: 90,
          ),
          Node(
            tag: NodeTag.untagged.name,
            id: _generateId(),
            title: 'Competitors',
            position: Offset(screenSize.width * 0.25, screenSize.height * 0.25),
            nodeType: NodeType.problem.name,
            color: '0xFFFFC107',
            description: 'Analysis of competitors.',
            size: 90,
          ),
        ];

      default:
        return;
    }

    setState(() {
      _nodes = [...templateNodes];
    });
  }
}

class ConnectionPainter extends CustomPainter {
  final Offset start;
  final Offset end;

  ConnectionPainter({required this.start, required this.end});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2;

    canvas.drawLine(start, end, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    const double dashWidth = 5;
    const double dashSpace = 5;
    final path = Path()..addOval(Rect.fromLTWH(0, 0, size.width, size.height));

    final PathMetric pathMetric = path.computeMetrics().first;
    double distance = 0;
    while (distance < pathMetric.length) {
      final extractPath =
          pathMetric.extractPath(distance, distance + dashWidth);
      canvas.drawPath(extractPath, paint);
      distance += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class DottedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const double dotRadius = 2;
    const double dotSpace = 5;
    final path = Path()..addOval(Rect.fromLTWH(0, 0, size.width, size.height));

    final PathMetric pathMetric = path.computeMetrics().first;
    double distance = 0;
    while (distance < pathMetric.length) {
      final extractPath =
          pathMetric.extractPath(distance, distance + dotRadius);
      canvas.drawPath(extractPath, paint);
      distance += dotRadius + dotSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
