import 'package:cop_belgium_app/screens/podcast_screens/widgets/podcast_image.dart';
import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:cop_belgium_app/utilities/responsive.dart';
import 'package:cop_belgium_app/widgets/bottomsheet.dart';
import 'package:cop_belgium_app/widgets/buttons.dart';

import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'podcast_screen.dart';

const paragrapgh =
    '''Mollit aute ea tempor esse in aliqua laboris ullamco mollit aliquip sit Lorem. Non proident minim nisi proident esse proident qui minim irure non ut incididunt reprehenderit laboris. Sint aute ipsum consequat nostrud anim incididunt irure tempor sunt. Voluptate reprehenderit quis amet pariatur minim deserunt laboris pariatur velit est aliqua culpa minim. Quis nisi cupidatat adipisicing commodo do sint culpa dolore. Dolor labore officia commodo id nostrud. Est sunt officia labore fugiat enim sunt ut eiusmod tempor duis incididunt.

Quis minim adipisicing sunt magna est deserunt fugiat veniam ut dolor ullamco dolor. Sit laborum elit sunt reprehenderit et sit sit laboris sint. Magna labore occaecat sint dolore enim ea cillum ullamco. Laboris id voluptate sint ullamco. Irure ipsum sint fugiat non irure id exercitation minim reprehenderit ex et. Pariatur cillum ad sint et amet laboris labore pariatur labore aliqua laborum eiusmod magna.

Elit Lorem amet commodo est sint cupidatat irure ut non occaecat ut officia est. Proident duis ea occaecat eu anim ea mollit ut adipisicing officia nulla nostrud consequat. Pariatur velit duis nostrud velit. Commodo et elit magna voluptate veniam deserunt eu velit exercitation fugiat enim non sint. Consequat incididunt dolor excepteur aliquip do. Eu excepteur tempor officia excepteur et.

Aute incididunt sit sunt tempor aliqua dolor dolor consectetur. Non minim ex labore amet consequat quis mollit velit id amet cupidatat deserunt. Sit in deserunt culpa anim. Ex velit laboris labore velit ut anim deserunt enim quis irure. Labore reprehenderit in reprehenderit consequat ex occaecat elit do laborum occaecat. Amet labore nostrud dolor incididunt deserunt velit excepteur ut ut ad nulla nisi occaecat nulla.

Occaecat officia tempor occaecat pariatur amet duis eiusmod deserunt consequat exercitation occaecat et. Duis labore et labore adipisicing qui cillum quis occaecat ex excepteur mollit mollit duis occaecat. Non duis duis consectetur aliqua voluptate. Tempor sint cillum Lorem quis Lorem sint nisi. Duis nisi magna in irure occaecat anim anim ex enim. Aliqua minim dolor ex veniam dolore sit culpa adipisicing eiusmod officia incididunt commodo.

Commodo ullamco laborum ipsum adipisicing dolor nisi. Consequat id enim ullamco qui ipsum proident ut culpa cupidatat magna. Anim quis proident esse dolor reprehenderit. Culpa sint culpa duis proident aliquip mollit commodo. Mollit do fugiat magna aliqua sit nostrud amet fugiat ut nulla reprehenderit fugiat. Voluptate labore et aliquip ex labore quis culpa est mollit veniam. Officia anim veniam eu laboris aute tempor magna sint nostrud.

Commodo occaecat laborum aliquip laboris consectetur dolor adipisicing culpa minim nulla et. Cillum sunt deserunt cillum voluptate ipsum fugiat. Commodo reprehenderit ipsum sit laborum occaecat voluptate. Officia elit irure magna eiusmod officia Lorem eiusmod in quis tempor consequat proident. Labore reprehenderit ex veniam aliquip.

Nostrud adipisicing dolor proident irure cupidatat velit dolore. Qui cupidatat mollit sint consectetur ipsum sint in commodo. Occaecat elit irure culpa do ut occaecat deserunt commodo fugiat. Amet exercitation dolore et labore. Eiusmod enim enim consectetur aliqua ut cillum ipsum quis.

Cupidatat veniam laboris laboris et cillum aliqua voluptate aliquip ad reprehenderit mollit. In dolor et laborum non laborum sunt pariatur. Deserunt nostrud irure sit quis commodo dolore id.''';
const double _iconSize = 36;

class PodcastPlayerScreen extends StatefulWidget {
  const PodcastPlayerScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<PodcastPlayerScreen> createState() => _PodcastPlayerScreenState();
}

class _PodcastPlayerScreenState extends State<PodcastPlayerScreen> {
  final popupMenuKey = GlobalKey<PopupMenuButtonState>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ResponsiveBuilder(
        builder: (context, screenInfo) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              _Header(),
              Flexible(
                child: SizedBox(
                  height: kContentSpacing32,
                ),
              ),
              _Image(),
              SizedBox(height: kContentSpacing16),
              _EpisodeTitle(),
              Flexible(child: SizedBox(height: kContentSpacing16)),
              _Slider(),
              SizedBox(height: kContentSpacing16),
              _PlaybackControls()
            ],
          );
        },
      ),
    );
  }
}

class _Header extends StatefulWidget {
  const _Header({Key? key}) : super(key: key);

  @override
  State<_Header> createState() => _HeaderState();
}

class _HeaderState extends State<_Header> {
  @override
  Widget build(BuildContext context) {
    void showEpisodeInfo() {
      showCustomBottomSheet(
        snappings: [0.78],
        context: context,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Deep thruths',
                style: kFontH6,
              ),
              SizedBox(height: kContentSpacing4),
              Text(
                'Church of Pentecost Belgium',
                style: kFontBody2,
              ),
              SizedBox(height: kContentSpacing24),
              Text(
                paragrapgh,
                style: kFontBody,
              ),
            ],
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomElevatedButton(
          padding: EdgeInsets.zero,
          child: const Icon(
            Icons.expand_more_rounded,
            size: _iconSize,
            color: kBlack,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        CustomElevatedButton(
          padding: EdgeInsets.zero,
          child: const Icon(
            Icons.info_outline_rounded,
            size: 28,
            color: kBlack,
          ),
          onPressed: showEpisodeInfo,
        )
      ],
    );
  }
}

class _Image extends StatelessWidget {
  const _Image({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenInfo = MediaQuery.of(context);

    if (screenInfo.size.height <= kScreenSizeTablet) {
      return Container();
    }
    if (MediaQuery.of(context).size.height <= kScreenSizeDesktop) {
      return const PodcastImage(
        imageUrl: unsplash,
        width: 160,
        height: 160,
      );
    }
    return const PodcastImage(
      imageUrl: unsplash,
      width: 260,
      height: 260,
    );
  }
}

class _EpisodeTitle extends StatelessWidget {
  const _EpisodeTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Text('Deep Truths', style: kFontH6),
        SizedBox(height: kContentSpacing4),
        Text('Church of Pentecost Belgium', style: kFontBody2),
      ],
    );
  }
}

class _Slider extends StatefulWidget {
  const _Slider({Key? key}) : super(key: key);

  @override
  State<_Slider> createState() => _SliderState();
}

class _SliderState extends State<_Slider> {
  double _currentSliderValue = 0.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Slider(
          value: _currentSliderValue,
          max: 100,
          // This is called when sliding is started.
          onChangeStart: (double value) {},
          // This is called when sliding has ended.
          onChangeEnd: (double value) {},
          // This is called when slider value is changed.
          onChanged: (double value) {
            setState(() {
              _currentSliderValue = value;
            });
          },
        ),
        const SizedBox(height: kContentSpacing4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              '0:00',
              style: kFontBody2,
            ),
            Text(
              '0:00',
              style: kFontBody2,
            ),
          ],
        )
      ],
    );
  }
}

class _PlaybackControls extends StatefulWidget {
  const _PlaybackControls({Key? key}) : super(key: key);

  @override
  State<_PlaybackControls> createState() => _PlaybackControlsState();
}

class _PlaybackControlsState extends State<_PlaybackControls> {
  bool isPlaying = false;

  final popupMenuKey = GlobalKey<PopupMenuButtonState>();

  double selectedPlaybackSpeed = 1.0;

  List<double> playBackOptions = [0.5, 1.0, 1.5, 2.0, 2.5];

  // final double _iconSize = 32;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildPlayBackSpeed(),
        _buildRewindButton(),
        _buildPlayButton(),
        _buildFastFowardButton(),
        _buildDownloadButton()
      ],
    );
  }

  Widget _buildPlayBackSpeed() {
    String playbackText = '1X';

    if (selectedPlaybackSpeed == 0.5) {
      playbackText = '0.5X';
    } else if (selectedPlaybackSpeed == 1) {
      playbackText = '1X';
    } else if (selectedPlaybackSpeed == 1.5) {
      playbackText = '1.5X';
    } else if (selectedPlaybackSpeed == 2.0) {
      playbackText = '2X';
    } else {
      playbackText = '2.5X';
    }

    return Flexible(
      child: CustomElevatedButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          popupMenuKey.currentState?.showButtonMenu();
        },
        child: PopupMenuButton<double>(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(kRadius),
            ),
          ),
          key: popupMenuKey,
          // Callback that sets the selected popup menu item.
          onSelected: (item) {},
          itemBuilder: (BuildContext context) => [
            PopupMenuItem(
              value: 0.5,
              child: const Text('0.5', style: kFontBody),
              onTap: () {
                selectedPlaybackSpeed = 0.5;
                setState(() {});
              },
            ),
            PopupMenuItem(
              value: 1,
              child: const Text('1', style: kFontBody),
              onTap: () {
                selectedPlaybackSpeed = 1.0;
                setState(() {});
              },
            ),
            PopupMenuItem(
              value: 1.5,
              child: const Text('1.5', style: kFontBody),
              onTap: () {
                selectedPlaybackSpeed = 1.5;
                setState(() {});
              },
            ),
            PopupMenuItem(
              value: 2,
              child: const Text('2', style: kFontBody),
              onTap: () {
                selectedPlaybackSpeed = 2.0;
                setState(() {});
              },
            ),
            PopupMenuItem(
              value: 2.5,
              child: const Text('2.5', style: kFontBody),
              onTap: () {
                selectedPlaybackSpeed = 2.5;
                setState(() {});
              },
            ),
          ],
          child: Text(
            playbackText,
            style: kFontBody.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildRewindButton() {
    return Flexible(
      child: CustomElevatedButton(
        padding: EdgeInsets.zero,
        child: const Icon(
          Icons.replay_30_rounded,
          size: _iconSize,
          color: kBlack,
        ),
        onPressed: () {},
      ),
    );
  }

  Widget _buildPlayButton() {
    return GestureDetector(
      child: Icon(
        isPlaying
            ? Icons.pause_circle_filled_rounded
            : Icons.play_circle_fill_rounded,
        size: 70,
        color: kBlue,
      ),
      onTap: () {
        isPlaying = !isPlaying;
        setState(() {});
      },
    );
  }

  Widget _buildFastFowardButton() {
    return Flexible(
      child: CustomElevatedButton(
        padding: EdgeInsets.zero,
        child: const Icon(
          Icons.forward_30_rounded,
          size: _iconSize,
          color: kBlack,
        ),
        onPressed: () {},
      ),
    );
  }

  Widget _buildDownloadButton() {
    return Flexible(
      child: CustomElevatedButton(
        padding: EdgeInsets.zero,
        child: const Icon(
          Icons.file_download_rounded,
          size: _iconSize,
          color: kBlack,
        ),
        onPressed: () {},
      ),
    );
  }
}
