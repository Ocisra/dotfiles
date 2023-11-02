#!/usr/bin/env python3

# Script copied on waybar's github but modified :  format and tooltip


import argparse
import logging
import sys
import signal
import gi
import json
import time
import threading
gi.require_version('Playerctl', '2.0')
from gi.repository import Playerctl, GLib

logger = logging.getLogger(__name__)

stop_time_tracker = False
time_thread = None


def write_output(text, player, text_time):
    logger.info('Writing output')

    output = {'text': text,
              'class': 'custom-' + player.props.player_name,
              'alt': player.props.player_name,
              'tooltip': text_time}

    sys.stdout.write(json.dumps(output) + '\n')
    sys.stdout.flush()


def ms_to_min(ms):
    rounded_min = int(ms / (1000*1000*60))
    rounded_s = int((ms - rounded_min*1000*1000*60) / (1000*1000))
    formatted_min = ""
    if rounded_min < 10:
        formatted_min = '0' + str(rounded_min)
    else:
        formatted_min = str(rounded_min)
    formatted_min += ':'
    if rounded_s < 10:
        formatted_min += '0' + str(rounded_s)
    else:
        formatted_min += str(rounded_s)
    return formatted_min

def update_time(track_info, player):
    if 'mpris:length' in player.props.metadata.keys():
        logger.info('Length field found')
        global stop_time_tracker
        while True:
            time.sleep(2)
            if stop_time_tracker:
                stop_time_tracker = False
                break
            total_time = ms_to_min(player.props.metadata['mpris:length'])
            actual_time = ms_to_min(player.props.position)
            text_time = actual_time + ' / ' + total_time
            write_output(track_info, player, text_time)
    return

def on_time_update(player, position, manager):
    logger.info('Recived new position')
    on_metadata(player, player.props.metadata, manager)

def on_play(player, status, manager):
    logger.info('Received new playback status')
    on_metadata(player, player.props.metadata, manager)


def on_metadata(player, metadata, manager):
    global stop_time_tracker
    global time_thread
    if time_thread != None:
        stop_time_tracker = True
        time_thread.join()
    logger.info('Received new metadata')
    track_info = ''
    text_time = 'NC'

    if 'mpris:length' in player.props.metadata.keys():
        total_time = ms_to_min(player.props.metadata['mpris:length'])
        actual_time = ms_to_min(player.props.position)
        text_time = actual_time + ' / ' + total_time

    if player.props.player_name == 'spotify' and \
            'mpris:trackid' in metadata.keys() and \
            ':ad:' in player.props.metadata['mpris:trackid']:
        track_info = 'AD PLAYING'
    elif player.get_artist() != '' and player.get_title() != '':
        track_info = '{artist} - {title}'.format(artist=player.get_artist(),
                                                 title=player.get_title())
    else:
        track_info = player.get_title()

    write_output(track_info, player, text_time)
    if player.props.playback_status == Playerctl.PlaybackStatus.PLAYING:
        time_thread = threading.Thread(target=update_time, args=(track_info, player))
        time_thread.start()
    else:
        stop_time_tracker = False



def on_player_appeared(manager, player, selected_player=None):
    if player is not None and (selected_player is None or player.name == selected_player):
        init_player(manager, player)
    else:
        logger.debug("New player appeared, but it's not the selected player, skipping")


def on_player_vanished(manager, player):
    global stop_time_tracker
    global time_thread
    logger.info('Player has vanished')
    stop_time_tracker = True
    time_thread.join()
    sys.stdout.write('\n')
    sys.stdout.flush()


def init_player(manager, name):
    logger.debug('Initialize player: {player}'.format(player=name.name))
    player = Playerctl.Player.new_from_name(name)
    player.connect('playback-status', on_play, manager)
    player.connect('metadata', on_metadata, manager)
    player.connect('seeked', on_time_update, manager)
    manager.manage_player(player)
    on_metadata(player, player.props.metadata, manager)


def signal_handler(sig, frame):
    global stop_time_tracker
    global time_thread
    logger.debug('Received signal to stop, exiting')
    sys.stdout.write('\n')
    sys.stdout.flush()
    # loop.quit()
    stop_time_tracker = True
    time_thread.join()
    sys.exit(0)


def parse_arguments():
    parser = argparse.ArgumentParser()

    # Increase verbosity with every occurence of -v
    parser.add_argument('-v', '--verbose', action='count', default=0)

    # Define for which player we're listening
    parser.add_argument('--player')

    return parser.parse_args()


def main():
    arguments = parse_arguments()

    # Initialize logging
    logging.basicConfig(stream=sys.stderr, level=logging.DEBUG,
                        format='%(name)s %(levelname)s %(message)s')

    # Logging is set by default to WARN and higher.
    # With every occurrence of -v it's lowered by one
    logger.setLevel(max((3 - arguments.verbose) * 10, 0))

    # Log the sent command line arguments
    logger.debug('Arguments received {}'.format(vars(arguments)))

    manager = Playerctl.PlayerManager()
    loop = GLib.MainLoop()

    manager.connect('name-appeared', lambda *args: on_player_appeared(*args, arguments.player))
    manager.connect('player-vanished', on_player_vanished)

    signal.signal(signal.SIGINT, signal_handler)
    signal.signal(signal.SIGTERM, signal_handler)

    for player in manager.props.player_names:
        if arguments.player is not None and arguments.player != player.name:
            logger.debug('{player} is not the filtered player, skipping it'
                         .format(player=player.name)
                         )
            continue

        init_player(manager, player)

    loop.run()


if __name__ == '__main__':
    main()
